extends Node

signal turn_ended

# Перечисление типов действий и их стоимости
enum ActionType { ROTATE = 1, MOVE, SHOOT }

var max_action_points: int = 5
var current_action_points: int

func initialize():
	reset_action_points()

func reset_action_points():
	current_action_points = max_action_points

func get_action_points() -> int:
	return current_action_points

# Списание очков действий
func spend_action_points(action: ActionType) -> bool:
	return false

func end_turn():
	emit_signal("turn_ended")
