class_name SignUpUI
extends Control

signal signup_request(email: String, username: String, password: String)
signal go_back

var email: String = ""
var username: String = ""
var password: String = ""
var password_repeat: String = ""

# gdlint: disable=max-line-length
@onready
var email_errors_label: ErrorLabel = $SignUpVContainer/SignUpFieldsHContainer/EmailAndUsernameVContainer/EmailVContainer/EmailErrors
@onready
var username_errors_label: ErrorLabel = $SignUpVContainer/SignUpFieldsHContainer/EmailAndUsernameVContainer/UsernameVContainer/UsernameErrors
@onready
var password_errors_label: ErrorLabel = $SignUpVContainer/SignUpFieldsHContainer/PasswordsVContainer/PasswordVContainer/PasswordErrors
@onready
var password_repeat_errors_label: ErrorLabel = $SignUpVContainer/SignUpFieldsHContainer/PasswordsVContainer/PasswordRepeatVContainer/PasswordRepeatErrors
@onready var signup_errors_label: ErrorLabel = $SignUpVContainer/SignUpErrors
# gdlint: enable=max-line-length


func show_signup_error(err_msg: String) -> void:
	signup_errors_label.show_error(err_msg)


func hide_signup_error() -> void:
	signup_errors_label.hide_error()


func _on_sign_up_button_pressed() -> void:
	print_rich("[color=green]Sign Up UI:[/color] пользователь нажал кнопку регистрации")
	if email.is_empty() or username.is_empty() or password.is_empty():
		signup_errors_label.show_error("Заполните все поля")
		return

	print_rich("[color=green]Sign Up UI:[/color] отправка сигнала на регистрацию")
	signup_errors_label.hide_error()
	signup_request.emit(email, username, password)


func _on_email_field_text_changed(new_email: String) -> void:
	var error: String = Validators.get_email_error(new_email)
	if error.is_empty():
		email = new_email
		email_errors_label.hide_error()
	else:
		email_errors_label.show_error(error)


func _on_username_field_text_changed(new_username: String) -> void:
	var error: String = Validators.get_username_error(new_username)
	if error.is_empty():
		username = new_username
		username_errors_label.hide_error()
	else:
		username_errors_label.show_error(error)


func _on_password_field_text_changed(new_password: String) -> void:
	var error: String = Validators.get_password_error(new_password)
	if error.is_empty():
		password = new_password
		password_errors_label.hide_error()
		_check_password_repeate()
	else:
		password_errors_label.show_error(error)


func _on_password_repeat_field_text_changed(new_password_rep: String) -> void:
	password_repeat = new_password_rep
	_check_password_repeate()


func _check_password_repeate() -> void:
	if password_repeat == password:
		password_repeat_errors_label.hide_error()
	else:
		password_repeat_errors_label.show_error("Пароль не совпадает")


func _on_return_button_pressed() -> void:
	print_rich("[color=green]Sign Up UI:[/color] нажата конпка 'назад'")
	go_back.emit()
