extends Node

const ACTION_TYPE = preload("res://assets/step_manager/step-manager.gd").ActionType
@export var step_manager: Node
@export var game_controller: Node
var players = []


func _ready() -> void:
	Buttons.turn_left_pressed.connect(rotate_unit)
	Buttons.turn_right_pressed.connect(rotate_unit)
	Buttons.move_pressed.connect(move_forward)
	Buttons.shoot_pressed.connect(shoot)


func initialize() -> void:
	Buttons.turn_left_pressed.connect(rotate_unit)
	Buttons.turn_right_pressed.connect(rotate_unit)
	Buttons.move_pressed.connect(move_forward)
	Buttons.shoot_pressed.connect(shoot)


func set_game_controller(game_controller_node: Node) -> void:
	game_controller = game_controller_node


func set_step_manager(manager: Node) -> void:
	step_manager = manager


func set_players(players_arr):
	players = players_arr


func rotate_unit(clockwise: bool):
	print("am rotate_unit")
	if step_manager.has_enough_ap(ACTION_TYPE.ROTATE):
		var index = game_controller.get_current_player_index()
		print(str(index))
		players[index].rotate_unit(clockwise)
		step_manager.spend_action_points(ACTION_TYPE.ROTATE)
		Labels.ap_changed.emit(index, step_manager.get_action_points())



func move_forward():
	print("am move_forward")
	if step_manager.has_enough_ap(ACTION_TYPE.MOVE):
		var index = game_controller.get_current_player_index()
		print(str(index))
		players[index].move_forward()
		step_manager.spend_action_points(ACTION_TYPE.MOVE)
		Labels.ap_changed.emit(index, step_manager.get_action_points())


func shoot(is_test: bool):
	print("am shoot")
	if step_manager.has_enough_ap(ACTION_TYPE.SHOOT):
		var index = game_controller.get_current_player_index()
		print(str(index))
		players[index].shoot(is_test)
		step_manager.spend_action_points(ACTION_TYPE.SHOOT)
		Labels.ap_changed.emit(index, step_manager.get_action_points())
