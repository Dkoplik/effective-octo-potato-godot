extends GutTest

const GameController = preload("res://assets/game_controller/GameController.tscn")
const StepManager = preload("res://assets/step_manager/StepManager.tscn")
const ACTION_TYPE = preload("res://assets/step_manager/step-manager.gd").ActionType

var game_controller = null
var step_manager = null


func before_each():
	game_controller = GameController.instantiate()
	#game_controller.initialize()
	add_child(game_controller)
	step_manager = game_controller.get_step_manager()


func test_turn_switching():
	assert_eq(game_controller.get_current_player_index(), 0)

	step_manager.end_turn()
	assert_eq(game_controller.get_current_player_index(), 1)

	step_manager.end_turn()
	assert_eq(game_controller.get_current_player_index(), 0)


func test_action_points_reset_on_turn_end():
	step_manager.spend_action_points(ACTION_TYPE.MOVE)
	step_manager.spend_action_points(ACTION_TYPE.SHOOT)

	assert_eq(game_controller.get_current_player_index(), 1)
	assert_eq(step_manager.get_action_points(), 5)

	step_manager.spend_action_points(ACTION_TYPE.SHOOT)
	step_manager.spend_action_points(ACTION_TYPE.ROTATE)
	step_manager.spend_action_points(ACTION_TYPE.ROTATE)
	assert_eq(game_controller.get_current_player_index(), 0)
	assert_eq(step_manager.get_action_points(), 5)
