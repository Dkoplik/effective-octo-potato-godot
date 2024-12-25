class_name LogInUI
extends Control

signal login_request(username: String, password: String)

var username: String = ""
var password: String = ""

@onready var login_errors_label: ErrorLabel = $LoginVContainer/LoginErrors


func show_login_error(err_msg: String) -> void:
	login_errors_label.show_error(err_msg)


func hide_login_error() -> void:
	login_errors_label.hide_error()


func _on_username_field_text_changed(new_text: String) -> void:
	username = new_text


func _on_password_field_text_changed(new_text: String) -> void:
	password = new_text


func _on_log_in_button_pressed() -> void:
	print_rich("[color=green]Log In UI:[/color] пользователь нажал на кнопку авторизации")
	if username.is_empty() or password.is_empty():
		login_errors_label.show_error("Заполните все поля")
		return

	print_rich("[color=green]Log In UI:[/color] отправка сигнала на авторизацию")
	login_errors_label.hide_error()
	login_request.emit(username, password)
