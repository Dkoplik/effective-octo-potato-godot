extends Node


func _ready() -> void:
	Labels.death.connect(show)


func show(player_id: int) -> void:
	Buttons.game_ended.emit()
	var victory_ui = preload("res://ui/win/WinScreen.tscn").instantiate()
	victory_ui.set_winner(player_id)
	get_tree().root.add_child(victory_ui)
