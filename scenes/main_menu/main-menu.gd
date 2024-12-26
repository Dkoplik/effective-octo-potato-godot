class_name MainMenu
extends Control

@onready var main_menu_ui: MainMenuUI = $MainMenuUI
@onready var log_in_ui: LogInUI = $LogInUI
@onready var sign_up_ui: SignUpUI = $SignUpUI
@onready var http_requester: AuthorizationHTTP = $AuthorizationHTTP
@onready var current_ui: Control = main_menu_ui


# Переключает текущий UI
func _go_to(new_ui: Control) -> void:
	print_rich("[color=green]Main Menu:[/color] переход к ", new_ui.name)
	current_ui.hide()
	new_ui.show()
	current_ui = new_ui


func _on_main_menu_ui_switch_to_play_request() -> void:
	pass  #TODO когда появиться UI браузера лобби


func _on_main_menu_ui_switch_to_log_in_request() -> void:
	_go_to(log_in_ui)


func _on_main_menu_ui_switch_to_sign_in_request() -> void:
	_go_to(sign_up_ui)


func _on_go_back() -> void:
	_go_to(main_menu_ui)


func _on_log_in_ui_login_request(username: String, password: String) -> void:
	var res: AuthorizationHTTP.HumanHTTPResult
	res = await http_requester.login_http_request(username, password)
	if res.is_error:
		log_in_ui.show_login_error(res.message)
	else:
		log_in_ui.hide_login_error()
		#TODO надо где-то делать сохранение текущего пользователя


func _on_sign_up_ui_signup_request(email: String, username: String, password: String) -> void:
	var res: AuthorizationHTTP.HumanHTTPResult
	res = await http_requester.sign_up_http_request(username, email, password)
	if res.is_error:
		sign_up_ui.show_signup_error(res.message)
	else:
		sign_up_ui.hide_signup_error()
