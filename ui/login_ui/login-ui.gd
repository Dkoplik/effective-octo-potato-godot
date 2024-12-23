class_name LogInUI
extends Control

signal login_request(username: String, password: String)

var username: String = ""
var password: String = ""

@onready var login_errors_label: Label = $LoginVContainer/LoginErrors

func _on_username_field_text_changed(new_text: String) -> void:
	username = new_text


func _on_password_field_text_changed(new_text: String) -> void:
	password = new_text


func show_login_error(err_msg: String) -> void:
	print_rich("[color=green]Log In UI:[/color] отображение ошибки авторизации")
	login_errors_label.text = err_msg


func _on_log_in_button_pressed() -> void:
	print_rich("[color=green]Log In UI:[/color] пользователь нажал на кнопку авторизации")
	login_request.emit(username, password)
