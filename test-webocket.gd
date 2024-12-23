extends Node2D

@onready var ws_client := $WebSocketClient
@onready var id_label := $"Id Field"
@onready var in_text := $"Incomming Text"
@onready var out_text := $TextEdit
@onready var status_label := $Status


func _process(delta: float) -> void:
	id_label.text = str(ws_client.uid)
	status_label.text = ws_client.get_str_connection_status()


func _on_connect_pressed() -> void:
	ws_client.connect_to_server("ws://localhost:3000/cable")


func _on_disconnect_pressed() -> void:
	ws_client.disconnect_from_server()


func _on_send_pressed() -> void:
	ws_client.send_string_message(out_text.text)


func _on_web_socket_client_general_message_recieved(from_id: int, json: Dictionary) -> void:
	out_text.text = JSON.stringify(json)
