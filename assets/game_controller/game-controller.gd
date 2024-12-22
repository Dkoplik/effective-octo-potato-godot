extends Node

@export var step_manager_scene: PackedScene
@export var player_scene: PackedScene
@export var player1_sprite: CompressedTexture2D
@export var player2_sprite: CompressedTexture2D
@export var map: Node = null

var _step_manager: Node = null
var current_player_index: int = 0

func _ready() -> void:
	initialize()

func initialize():
	pass

func get_step_manager():
	return _step_manager

func get_current_player_index():
	return current_player_index

func _start_turn_for_current_player():
	pass

func _on_turn_ended():
	pass
