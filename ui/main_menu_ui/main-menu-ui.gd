class_name MainMenuUI
extends Control

signal switch_to_play_request
signal switch_to_log_in_request
signal switch_to_sign_in_request
signal log_out_request

var is_user_authorized := false
var user_name := "":
	set = _set_user_name

@onready var user_name_label: Label = $CornerVContainer/UserLabelHContainer/UserName
@onready var authorized_buttons: Container = $CornerVContainer/LogOutHContainer
@onready var unauthorized_buttons: Container = $CornerVContainer/LogSignInHContainer


# Лучше этому UI не выходить за пределы своей зоны ответственности и делегировать её через сигналы
func _on_play_button_pressed() -> void:
	print_rich("[color=green]Main Menu UI:[/color] нажата кнопка play")
	switch_to_play_request.emit()


func _on_log_in_button_pressed() -> void:
	print_rich("[color=green]Main Menu UI:[/color] нажата кнопка авторизации")
	switch_to_log_in_request.emit()


func _on_sign_in_button_pressed() -> void:
	print_rich("[color=green]Main Menu UI:[/color] нажата кнопка регистрации")
	switch_to_sign_in_request.emit()


func _on_log_out_button_pressed() -> void:
	print_rich("[color=green]Main Menu UI:[/color] нажата кнопка log out")
	log_out_request.emit()


func _set_user_name(val: String) -> void:
	user_name = val
	if not user_name.is_empty():
		print_rich("[color=green]Main Menu UI:[/color] пользователь авторизовался, изменение UI")
		is_user_authorized = true
		user_name_label.text = user_name
		authorized_buttons.show()
		unauthorized_buttons.hide()
	else:
		print_rich("[color=green]Main Menu UI:[/color] пользователь разлогинился, изменение UI")
		is_user_authorized = false
		user_name_label.text = "Неизвестный пользователь"
		authorized_buttons.hide()
		unauthorized_buttons.show()
