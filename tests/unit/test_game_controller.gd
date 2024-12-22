extends GutTest

const GameController = preload("res://assets/game_controller/GameController.tscn")
const StepManager = preload("res://assets/step_manager/StepManager.tscn")

var game_controller = null
var step_manager = null

func before_each():
	game_controller = GameController.instantiate()
	game_controller.initialize()
	add_child(game_controller)
	step_manager = game_controller.get_step_manager()

func test_turn_switching():
	assert_eq(game_controller.get_current_player_index(), 0)

	step_manager.end_turn()
	assert_eq(game_controller.get_current_player_index(), 1)

	step_manager.end_turn()
	assert_eq(game_controller.get_current_player_index(), 0)

func test_action_points_reset_on_turn_end():
	step_manager.spend_action_points(StepManager.ActionType.MOVE)
	step_manager.spend_action_points(StepManager.ActionType.SHOOT)

	assert_eq(game_controller.get_current_player_index(), 1)
	assert_eq(step_manager.get_action_points(), 5)

	step_manager.spend_action_points(StepManager.ActionType.SHOOT)
	step_manager.spend_action_points(StepManager.ActionType.ROTATE)
	step_manager.spend_action_points(StepManager.ActionType.ROTATE)
	assert_eq(game_controller.get_current_player_index(), 0)
	assert_eq(step_manager.get_action_points(), 5)
