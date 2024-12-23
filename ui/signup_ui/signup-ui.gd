class_name SignUpUI
extends Control

signal signup_request(email: String, username: String, password: String)

var email: String = ""
var username: String = ""
var password: String = ""
var password_repeat: String = ""

# gdlint: disable=max-line-length
@onready var email_errors_label: Label = $SignUpVContainer/SignUpFieldsHContainer/EmailAndUsernameVContainer/EmailVContainer/EmailErrors
@onready var username_errors_label: Label = $SignUpVContainer/SignUpFieldsHContainer/EmailAndUsernameVContainer/UsernameVContainer/UsernameErrors
@onready var password_errors_label: Label = $SignUpVContainer/SignUpFieldsHContainer/PasswordsVContainer/PasswordVContainer/PasswordErrors
@onready var password_repeat_errors_label: Label = $SignUpVContainer/SignUpFieldsHContainer/PasswordsVContainer/PasswordRepeatVContainer/PasswordRepeatErrors
@onready var signup_errors_label: Label = $SignUpVContainer/SignUpErrors
# gdlint: enable=max-line-length


func _on_sign_up_button_pressed() -> void:
	print_rich("[color=green]Sign Up UI:[/color] пользователь нажал кнопку регистрации")
	if email.is_empty() or username.is_empty() or password.is_empty():
		return
	print_rich("Отправка сигнала на регистрацию")
	signup_request.emit(email, username, password)


func _on_email_field_text_changed(new_text: String) -> void:
	if _is_valid_email(new_text):
		email = new_text
		_hide_email_error()
	else:
		_show_email_error("Некорректная почта")


func _is_valid_email(text: String) -> bool:
	# https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address
	var regexpr := (
		RegEx
		. create_from_string(
			# gdlint:ignore = max-line-length
			"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
		)
	)
	var regexpr_match: RegExMatch = regexpr.search(text)
	if regexpr_match == null:
		return false
	return regexpr_match.get_string() == text


func _on_username_field_text_changed(new_text: String) -> void:
	if _is_valid_username(new_text):
		username = new_text
		_hide_username_error()


func _is_valid_username(text: String) -> bool:
	if text.length() < 3:
		_show_username_error("Имя пользователя должно быть не менее 3 символов")
		return false

	if text.length() > 20:
		_show_username_error("Имя пользователя должно быть не более 20 символов")
		return false

	var valid_letters := RegEx.create_from_string("[a-zA-Z0-9_]+")
	var regexpr_match: RegExMatch = valid_letters.search(text)
	if regexpr_match == null:
		_show_username_error("Имя пользователя содержит некорректные символы")
		return false
	if regexpr_match.get_string() != text:
		_show_username_error("Имя пользователя содержит некорректные символы")
		return false

	return true


func _on_password_field_text_changed(new_text: String) -> void:
	if _is_valid_password(new_text):
		password = new_text
		_hide_password_error()
		_on_password_repeat_field_text_changed(password_repeat)


func _is_valid_password(text: String) -> bool:
	if text.length() < 8:
		_show_password_error("Пароль должен быть не менее 8 символов")
		return false

	if text.length() < 128:
		_show_password_error("Пароль должен быть не более 128 символов")

	var has_number := RegEx.create_from_string("[0-9]")
	if has_number.search_all(text).size() == 0:
		_show_password_error("Пароль должен содержать хотя бы одну цифру")
		return false

	var has_lower_case := RegEx.create_from_string("[a-zа-я]")
	if has_lower_case.search_all(text).size() == 0:
		_show_password_error("Пароль должен содержать хотя бы одну строчную букву")
		return false

	var has_upper_case := RegEx.create_from_string("[A-ZА-Я]")
	if has_upper_case.search_all(text).size() == 0:
		_show_password_error("Пароль должен содержать хотя бы одну заглавную букву")
		return false

	return true


func _on_password_repeat_field_text_changed(new_text: String) -> void:
	password_repeat = new_text
	if _is_valid_password_repeat(password_repeat):
		_hide_password_repeat_error()
	else:
		_show_password_repeat_error("Пароль не совпадает")


func _is_valid_password_repeat(text: String) -> bool:
	return text == password


func show_signup_error(err_msg: String) -> void:
	print_rich("[color=green]Log In UI:[/color] отображение ошибки регистрации")
	signup_errors_label.text = err_msg


func hide_signup_error() -> void:
	print_rich("[color=green]Log In UI:[/color] убрать ошибки регистрации")
	signup_errors_label.text = ""


func _show_email_error(err_msg: String) -> void:
	print_rich("[color=green]Sign Up UI:[/color] отображение ошибки в почте")
	email_errors_label.text = err_msg


func _hide_email_error() -> void:
	print_rich("[color=green]Sign Up UI:[/color] убрать ошибки в почте")
	email_errors_label.text = ""


func _show_username_error(err_msg: String) -> void:
	print_rich("[color=green]Sign Up UI:[/color] отображение ошибки имени пользователя")
	username_errors_label.text = err_msg


func _hide_username_error() -> void:
	print_rich("[color=green]Sign Up UI:[/color] убрать ошибки имени пользователя")
	username_errors_label.text = ""


func _show_password_error(err_msg: String) -> void:
	print_rich("[color=green]Sign Up UI:[/color] отображение ошибки в пароле")
	password_errors_label.text = err_msg


func _hide_password_error() -> void:
	print_rich("[color=green]Sign Up UI:[/color] убрать ошибки в пароле")
	password_errors_label.text = ""


func _show_password_repeat_error(err_msg: String) -> void:
	print_rich("[color=green]Sign Up UI:[/color] отображение ошибки при повторе пароля")
	password_repeat_errors_label.text = err_msg


func _hide_password_repeat_error() -> void:
	print_rich("[color=green]Sign Up UI:[/color] убрать ошибки при повторе пароля")
	password_repeat_errors_label.text = ""
