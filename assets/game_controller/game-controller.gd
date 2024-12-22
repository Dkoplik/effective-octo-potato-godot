extends Node

const FACING_DIRECTION = preload("res://assets/player/player.gd").FacingDirection

@export var step_manager_scene: PackedScene
@export var action_manager_scene: PackedScene
@export var player_scene: PackedScene
@export var player1_sprite: CompressedTexture2D
@export var player2_sprite: CompressedTexture2D
@export var map: Node = null

var current_player_index: int = 0
var players = []
var _step_manager: Node = null
var _action_manager: Node = null


func _ready() -> void:
	print("gc ready")
	_initialize_step_manager()
	_initialize_players()
	_initialize_action_manager()

	current_player_index = 0
	_start_turn_for_current_player()


func _initialize_step_manager() -> void:
	_step_manager = step_manager_scene.instantiate()
	get_tree().root.add_child(_step_manager)
	_step_manager.initialize()
	_step_manager.connect("turn_ended", _on_turn_ended)


func _initialize_players() -> void:
	var player1 = player_scene.instantiate()
	var player2 = player_scene.instantiate()

	add_child(player1)
	add_child(player2)

	player1.set_map(map)
	player2.set_map(map)
	player1.set_position_in_tiles(Vector2i(1, 6))
	player2.set_position_in_tiles(Vector2i(18, 6))
	player1.set_facing_direction(FACING_DIRECTION.EAST)
	player2.set_facing_direction(FACING_DIRECTION.WEST)
	player1.set_id(0)
	player2.set_id(1)
	player1.set_sprite(player1_sprite)
	player2.set_sprite(player2_sprite)

	players.append(player1)
	players.append(player2)


func _initialize_action_manager() -> void:
	_action_manager = action_manager_scene.instantiate()
	_action_manager.initialize()
	_action_manager.set_game_controller(self)
	_action_manager.set_step_manager(_step_manager)
	_action_manager.set_players(players)
	get_tree().root.add_child(_action_manager)


func get_step_manager():
	return _step_manager


func get_current_player_index():
	return current_player_index


func _start_turn_for_current_player():
	_step_manager.reset_action_points()
	print("Player ", current_player_index + 1, "'s turn")


func _on_turn_ended():
	current_player_index = (current_player_index + 1) % 2
	_start_turn_for_current_player()
