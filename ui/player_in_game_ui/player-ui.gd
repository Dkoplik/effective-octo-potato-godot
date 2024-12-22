extends Control

func _ready() -> void:
	Labels.health_changed.connect(change_health)
	Labels.ap_changed.connect(change_ap)

func _on_turn_left_pressed() -> void:
	Buttons.turn_left_pressed.emit(false)


func _on_turn_right_pressed() -> void:
	Buttons.turn_left_pressed.emit(true)


func _on_move_pressed() -> void:
	Buttons.move_pressed.emit()


func _on_shot_pressed() -> void:
	Buttons.shoot_pressed.emit(false)

func change_health(player_id: int, health: int) -> void:
	var label
	if player_id == 0:
		label = $CanvasLayer/Lives1/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/Count_HP1
	else:
		label = $CanvasLayer/Lives2/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/Count_HP2
	label.text = str(health)

func change_ap(player_id: int, ap_ammount: int) -> void:
	if player_id == 0:
		$CanvasLayer/Lives1/MarginContainer/VBoxContainer/Steps1.text = "steps: " + str(ap_ammount)
	else:
		$CanvasLayer/Lives2/MarginContainer/VBoxContainer/Steps2.text = "steps: " + str(ap_ammount)
