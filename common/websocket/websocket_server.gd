extends Node
class_name Server


func _ready() -> void:
	var server = WebSocketPeer.new()
	multiplayer.multiplayer_peer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
