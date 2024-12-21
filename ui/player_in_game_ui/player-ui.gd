extends Control


func _on_turn_left_pressed() -> void:
	Buttons.turn_left_pressed.emit(false)


func _on_turn_right_pressed() -> void:
	Buttons.turn_left_pressed.emit(true)


func _on_move_pressed() -> void:
	Buttons.move_pressed.emit()


func _on_shot_pressed() -> void:
	pass  # Replace with function body.
