class_name ServerBrowser
extends Control

signal connect_to_lobby
signal go_back

# gdlint: disable=max-line-length
var server_entry_scene: PackedScene = preload("res://ui/server_browser_ui/server_entry/server_entry.tscn")

@onready var server_list: Control = $VBoxContainer/ScrollContainer/ServerList
@onready var browser_http: BrowserHTTP = $BrowserHTTP


func _on_return_button_pressed() -> void:
	print_rich("[color=green]Server Browser:[/color] нажата кнопка 'назад'")
	go_back.emit()


func _on_refresh_button_pressed() -> void:
	var res: HumanHTTPResult = await browser_http.get_server_list_request()

	# Очистка старого списка
	for child in server_list.get_children():
		server_list.remove_child(child)

	if res.is_error:
		return

	var servers: Dictionary = JSON.parse_string(res.message)
	for server: Dictionary in servers:
		var host_username: String = server.get("username")
		var players_amount: int = server.get("amount")

		var server_entry: ServerEntry = server_entry_scene.instantiate()
		server_entry.host_username = host_username
		server_entry.players_amount = players_amount

		server_list.add_child(server_entry)


func _on_connect_button_pressed() -> void:
	pass
