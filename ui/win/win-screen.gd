extends Control


func set_winner(player_id: int) -> void:
	player_id = (player_id + 1) % 2 + 1
	$PanelContainer/VBoxContainer/WinnetText.text = "Игрок " + str(player_id) + " победил"


# переход в лобби
func _on_button_pressed() -> void:
	pass  # Replace with function body.
