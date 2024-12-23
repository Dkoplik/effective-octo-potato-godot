class_name WebSocketClient
extends Node

# Пришёл какой-то JSON. Тут нет обработок даже на определение типа сообщения.
signal general_message_recieved(from_id: int, json: Dictionary)
# Пришёл JSON с текстовым сообщением. Сообщение сразу извлечено и передано параметром.
signal text_message_recieved(from_id: int, text: String)

enum MessageType { TEXT_MESSAGE }

var uid: int = -1  # uid должен быть положительным, поэтому через -1 обозначаем то, что его ещё нет
var connection_status := WebSocketPeer.STATE_CLOSED
var _ws_peer := WebSocketPeer.new()


func _process(_delta: float) -> void:
	_web_socket_poll()


# Подключиться к указанному серверу, данный узел становиться WebSocket клиентом и указанное
# соединение теперь отвечает за RPC вызовы для этого узла и всех дочерних. Так же сохраняет
# свой уникальный id.
func connect_to_server(url: String) -> void:
	if connection_status != WebSocketPeer.STATE_CLOSED:
		push_error("Прошлое соединение не закрыто")
		return

	var error: int = _ws_peer.connect_to_url(url)
	if error:
		push_error("Ошибка с кодом ", error, " при подключении к url: ", url)
		return

	connection_status = WebSocketPeer.STATE_CONNECTING
	print("Идёт соединение по ссылке ", url, " ...")


# Отключает клиента от WebSocket сервера.
func disconnect_from_server() -> void:
	_ws_peer.close(1000)


# Отправляет строковое сообщение в JSON формате с указанием типа сообщения.
func send_string_message(message: String) -> void:
	#region Проверка входных параметров
	if message == null or message.is_empty():
		push_error("Попытка отправить пустое сообщение")
		return
	#endregion

	var packet: Dictionary = {"message_type": MessageType.TEXT_MESSAGE, "text": message}
	var buffer: String = JSON.stringify(packet)
	var error: int = _ws_peer.send_text(buffer)
	if error:
		push_error("Ошибка с кодом ", error, " при попытке отправить сообщение: ", message)
		return
	print("Клиент с uid ", uid, " репортинг: сообщение отправлено")


func get_str_connection_status() -> String:
	if connection_status == WebSocketPeer.STATE_OPEN:
		return "CONNECTED"
	elif connection_status == WebSocketPeer.STATE_CONNECTING:
		return "CONNECTING"
	elif connection_status == WebSocketPeer.STATE_CLOSING:
		return "CLOSING"
	else:
		return "DISCONNECTED"


# Возвращает true, если находиться в соединении. Для закрытого состояния или
# процесса подключения возвращает false.
func is_ws_connected() -> bool:
	return connection_status == WebSocketPeer.STATE_OPEN


# Обрабатывает / поддерживает WebSocket соединение с сервером.
func _web_socket_poll() -> void:
	if connection_status == WebSocketPeer.STATE_CLOSED:
		return

	_ws_peer.poll()
	connection_status = _ws_peer.get_ready_state()

	while is_ws_connected() and _ws_peer.get_available_packet_count() > 0:
		_process_incomming_messages()


func _process_incomming_messages() -> void:
	print("Клиент с uid ", uid, " репортинг: обнаружены входящие пакеты")
	var buffer: PackedByteArray = _ws_peer.get_packet()
	var error: int = _ws_peer.get_packet_error()
	if error:
		push_error("Ошибка ", error, " во время получения сообщения клиентом ", uid)
		return
	print("Клиент с uid ", uid, " репортинг: успешное получение пакета от клиента")

	var json: Dictionary = JSON.parse_string(buffer.get_string_from_utf8())
	if json == null:
		push_error("Не удалось пропарсить JSON")
		return
	print("Клиент с uid ", uid, " репортинг: успешный парсинг JSON'а от клиента")
	general_message_recieved.emit(-999, json)
	_process_json_type(-999, json)


# Обрабатывает входящий JSON и испускает более конкретные сигналы, в зависимости
# от типа сообщения в JSON.
func _process_json_type(from_id: int, json: Dictionary) -> void:
	if json == null:
		push_error("Получен пустой JSON")
		return

	print(json)
	if (json.get("message_type") == null):
		return
	var message_type: MessageType = json.get("message_type")

	match message_type:
		MessageType.TEXT_MESSAGE:
			var text: String = json.get("text")
			if text == null:
				push_error("Не удалось получить текстовое сообщение от ", from_id, ", хотя JSON получен")
			text_message_recieved.emit(from_id, text)
