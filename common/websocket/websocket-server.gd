class_name WebSocketServer
extends Node

var uid: int = -1
var _ws_peer = WebSocketMultiplayerPeer.new()


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_ws_peer.poll()
	if _ws_peer.get_available_packet_count() > 0:
		print("У сервера появились входящие пакеты")


func create_server(port: int) -> void:
#region Проверка входных параметров
	if port > 49151:
		push_warning("Используется приватный/динамический порт:", port)
#endregion
	
	var error: int = _ws_peer.create_server(port)
	if error:
		push_error("Ошибка ", error, " при создании сервера")
		return
	
	multiplayer.set_multiplayer_peer(_ws_peer)
	uid = multiplayer.get_unique_id()


func _on_peer_connected(id: int) -> void:
	print("Сервер ", uid, " репортинг: присоединился клиент с id", id)

func _on_peer_disconnected(id: int) -> void:
	print("Сервер ", uid, " репортинг: отсоединился клиент с id", id)
