extends Button

var peer = WebSocketMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../Id Field".text = str(peer.get_unique_id())
	
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var data_string = packet.get_string_from_utf8()
			var data = JSON.parse_string(data_string)
			print(peer.get_unique_id(), " got: ", data)
			$"../Income Text Field".text = data_string


func _on_pressed() -> void:
	peer.create_server(8915)
	$"../Type".text = "server"
	print("Сервер начат")


func _on_send_pressed() -> void:
	var message = {
		"text": "aboba",
		"from": peer.get_unique_id()
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())


func _on_connect_pressed() -> void:
	peer.create_client("ws://localhost:3000/cable")
	$"../Type".text = "client"
	print("Клиент начат")


func _on_disconnect_pressed() -> void:
	peer.close()
	print("Клиент закрыт")
