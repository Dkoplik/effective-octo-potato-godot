extends GutTest

const StepManager = preload("res://assets/step_manager/StepManager.tscn")
const ACTION_TYPE = preload("res://assets/step_manager/step-manager.gd").ActionType
var step_manager = null


func before_each():
	step_manager = StepManager.instantiate()
	step_manager.initialize()


func test_action_points_spent_correctly():
	assert_eq(step_manager.get_action_points(), 5)
	var success = step_manager.spend_action_points(ACTION_TYPE.MOVE)
	assert_true(success)
	assert_eq(step_manager.get_action_points(), 3)

	success = step_manager.spend_action_points(ACTION_TYPE.ROTATE)
	assert_true(success)
	assert_eq(step_manager.get_action_points(), 2)

	step_manager.reset_action_points()
	success = step_manager.spend_action_points(ACTION_TYPE.SHOOT)
	assert_true(success)
	assert_eq(step_manager.get_action_points(), 2)


func test_spend_action_points_failure():
	step_manager.spend_action_points(ACTION_TYPE.SHOOT)
	var success = step_manager.spend_action_points(ACTION_TYPE.SHOOT)
	assert_false(success)
	assert_eq(step_manager.get_action_points(), 2)


func test_reset_action_points():
	step_manager.spend_action_points(ACTION_TYPE.MOVE)
	step_manager.reset_action_points()
	assert_eq(step_manager.get_action_points(), 5)
