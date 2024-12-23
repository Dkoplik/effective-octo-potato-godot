class_name WebSocketClient
extends Node

# Пришёл какой-то JSON. Тут нет обработок даже на определение типа сообщения.
signal general_message_recieved(from_id: int, json: Dictionary)
# Пришёл JSON с текстовым сообщением. Сообщение сразу извлечено и передано параметром.
signal text_message_recieved(from_id: int, text: String)

enum MessageType { TEXT_MESSAGE }

var uid: int = -1 # uid должен быть положительным, поэтому через -1 обозначаем то, что его ещё нет
var connection_status := MultiplayerPeer.ConnectionStatus.CONNECTION_DISCONNECTED
var _ws_peer := WebSocketMultiplayerPeer.new()


func _ready() -> void:
#region Подключение multiplayer сигналов к данному клиенту
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
#endregion
	multiplayer.set_multiplayer_peer(null) # изначально нет никакого соединения


func _process(_delta: float) -> void:
	connection_status = _ws_peer.get_connection_status()
	_ws_peer.poll()
	if _ws_peer.get_available_packet_count() > 0:
		print("Обнаружен пакет")
	#_web_socket_poll()


# Подключиться к указанному серверу, данный узел становиться WebSocket клиентом и указанное
# соединение теперь отвечает за RPC вызовы для этого узла и всех дочерних. Так же сохраняет
# свой уникальный id.
func connect_to_server(address_prefix: String, address: String, port: int) -> void:
#region Проверка входных параметров
	if multiplayer.has_multiplayer_peer():
		push_error("Соединение уже организовано, необходимо прервать старое соединение")
		return

	if address_prefix == null or address_prefix.is_empty():
		push_error("Пустой префикс для url")
		return

	if address_prefix != "ws://" and address_prefix != "wss://":
		push_error("Неизвестный префикс ", address_prefix)
		return

	if address == null or address.is_empty():
		push_error("Пустой адрес для url")
		return

	if address == "localhost":
		address = "127.0.0.1"

	if not address.is_valid_ip_address():
		push_error("Строка", address, "не является ip адресом")
		return

	if port > 49151:
		push_warning("Используется приватный/динамический порт:", port)
#endregion

	var url: String = address_prefix + address + ":" + str(port)
	var error: int = _ws_peer.create_client(url)
	if error:
		push_error("Ошибка с кодом ", error, " при подключении к url: ", url)
		return

	multiplayer.set_multiplayer_peer(_ws_peer)
	print("Идёт соединение по ссылке ", url, " ...")


# Отключает клиента от WebSocket сервера.
func disconnect_from_server() -> void:
	_ws_peer.close()


# Отправляет строковое сообщение в JSON формате с указанием типа сообщения.
func send_string_message(message: String) -> void:
#region Проверка входных параметров
	if message == null or message.is_empty():
		push_error("Попытка отправить пустое сообщение")
		return
#endregion

	var packet: Dictionary = {"message_type": MessageType.TEXT_MESSAGE, "text": message}
	var buffer: PackedByteArray = JSON.stringify(packet).to_utf8_buffer()
	var error: int = _ws_peer.put_packet(buffer)
	if error:
		push_error("Ошибка с кодом ", error, " при попытке отправить сообщение: ", message)
		return
	print("Клиент с uid ", uid, " репортинг: сообщение отправлено")


# Обрабатывает / поддерживает WebSocket соединение с сервером.
func _web_socket_poll() -> void:
	_ws_peer.poll()
	if _ws_peer.get_available_packet_count() == 0:
		return  # нет сообщений

	print("Клиент с uid ", uid, " репортинг: обнаружены входящие пакеты")
	var sender_id: int = _ws_peer.get_packet_peer()
	var buffer: PackedByteArray = _ws_peer.get_packet()
	var error: int = _ws_peer.get_packet_error()
	if error:
		push_error("Ошибка ", error, " во время получения сообщения клиентом ", uid, " от ", sender_id)
		return
	print("Клиент с uid ", uid, " репортинг: успешное получение пакета от клиента ", sender_id)

	var json: Dictionary = JSON.parse_string(buffer.get_string_from_utf8())
	if json == null:
		push_error("Не удалось пропарсить JSON")
		return
	print("Клиент с uid ", uid, " репортинг: успешный парсинг JSON'а от клиента ", sender_id)
	general_message_recieved.emit(sender_id, json)
	_process_json_type(sender_id, json)


# Обрабатывает входящий JSON и испускает более конкретные сигналы, в зависимости
# от типа сообщения в JSON.
func _process_json_type(from_id: int, json: Dictionary) -> void:
	var message_type: MessageType = json.get("message_type")
	if message_type == null:
		push_error("Получен JSON от ", from_id, " без указания типа сообщения")
		return

	match message_type:
		MessageType.TEXT_MESSAGE:
			var text: String = json.get("text")
			if text == null:
				push_error("Не удалось получить текстовое сообщение от ", from_id, ", хотя JSON получен")
			text_message_recieved.emit(from_id, text)


# Обработка успешного подключения к серверу
func _on_connected_to_server() -> void:
	uid = multiplayer.get_unique_id()
	print("Клиент с uid ", uid, " репортинг: успешное подключение к серверу")


# Обработка провального подключения к серверу
func _on_connection_failed() -> void:
	print("Клиент с uid ", uid, " репортинг: не удалось подключиться к серверу")
	multiplayer.set_multiplayer_peer(null)
	uid = -1


# Обработка подключения какого-то клиента (в том числе сервера)
func _on_peer_connected(id: int) -> void:
	print("Клиент с uid ", uid, " репортинг: появилось подключение с id ", id)


# Обработка отключения какого-то клиента от сервера
func _on_peer_disconnected(id: int) -> void:
	print("Клиент с uid ", uid, " репортинг: id ", id, "отключился")


# Обработка отсоединения от сервера
func _on_server_disconnected() -> void:
	print("Клиент с uid ", uid, " репортинг: разорвано соединение с сервером")
	multiplayer.set_multiplayer_peer(null)
	uid = -1
