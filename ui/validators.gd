class_name Validators


# Если есть ошибка - возвращает строку с текстовым описанием ошибки.
# При отсутствии ошибок возвращает пустую строку.
static func get_email_error(email: String) -> String:
	# RegEx взят отсюда:
	# https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address
	# gdlint:ignore = max-line-length
	var str_regex := "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
	var valid_email := RegEx.new()
	var error: int = valid_email.compile(str_regex)
	if error:
		push_error("Ошибка ", error, " во время создания regexpr для email")
		return "Ошибка в regexpr"

	var valid_emails: Array[RegExMatch] = valid_email.search_all(email)
	if valid_emails.size() != 1:
		return "Некорректная почта"  # Вся строка не является корректной
	if valid_emails[0].get_string() != email:
		return "Некорректная почта"  # Только какая-то подстрока корректна
	return ""  # всё норм


# Если есть ошибка - возвращает строку с текстовым описанием ошибки.
# При отсутствии ошибок возвращает пустую строку.
static func get_username_error(username: String) -> String:
	if username.length() < 3:
		return "Имя пользователя должно быть не менее 3 символов"

	if username.length() > 20:
		return "Имя пользователя должно быть не более 20 символов"

	var valid_letters := RegEx.create_from_string("[a-zA-Z0-9_]+")
	var valid_usernames: Array[RegExMatch] = valid_letters.search_all(username)
	if valid_usernames.size() != 1:
		return "Имя пользователя содержит некорректные символы"
	if valid_usernames[0].get_string() != username:
		return "Имя пользователя содержит некорректные символы"

	return ""


# Если есть ошибка - возвращает строку с текстовым описанием ошибки.
# При отсутствии ошибок возвращает пустую строку.
static func get_password_error(password: String) -> String:
	if password.length() < 8:
		return "Пароль должен быть не менее 8 символов"

	if password.length() > 128:
		return "Пароль должен быть не более 128 символов"

	var numbers := RegEx.create_from_string("[0-9]")
	if numbers.search_all(password).size() == 0:
		return "Пароль должен содержать хотя бы одну цифру"

	var lower_case_letters := RegEx.create_from_string("[a-zа-я]")
	if lower_case_letters.search_all(password).size() == 0:
		return "Пароль должен содержать хотя бы одну строчную букву"

	var upper_case_letters := RegEx.create_from_string("[A-ZА-Я]")
	if upper_case_letters.search_all(password).size() == 0:
		return "Пароль должен содержать хотя бы одну заглавную букву"

	return "" # Всё норм
