class_name ServerEntry
extends Control

var host_username := "unknown":
	set = set_host_username
var players_amount: int = 1:
	set = set_players_amount

@onready var username_label: Label = $HBoxContainer/HostUsernameLabel
@onready var player_amount_label: Label = $HBoxContainer/PlayerAmountLabel
@onready var connect_button: Button = $HBoxContainer/Button


func _init(host_username := "unknown", players_amount: int = 1) -> void:
	self.host_username = host_username
	self.players_amount = players_amount


func _ready() -> void:
	username_label.text = host_username
	player_amount_label.text = str(players_amount) + "/2"


func set_host_username(new_host: String) -> void:
	host_username = new_host
	username_label.text = host_username


func set_players_amount(new_amount: int) -> void:
	players_amount = new_amount
	player_amount_label.text = str(players_amount) + "/2"
