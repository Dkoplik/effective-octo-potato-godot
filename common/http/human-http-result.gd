class_name HumanHTTPResult
extends Resource

var is_error := false
var message: String = ""


func _init(is_error := false, message := "") -> void:
	self.is_error = is_error
	self.message = message
