class_name ErrorLabel
extends Label


func hide_error() -> void:
	# Только если до этого была ошибка, дабы убрать спам в консоль
	if self.text != "":
		print_rich("[color=green]Sign Up UI:[/color] убрать ошибки в ", self.name)
		self.text = ""


func show_error(error: String) -> void:
	# Только если ошибка поменялась, дабы убрать спам в консоль
	if error != self.text:
		print_rich("[color=green]Sign Up UI:[/color] отображение ошибки в ", self.name)
		self.text = error
