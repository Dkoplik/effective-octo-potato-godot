class_name AuthorizationHTTP
extends AwaitableHTTP


# "Структура" под результат запроса
class HumanHTTPResult:
	extends Resource

	var is_error := false
	var message: String = ""


@export var log_in_url := "http://localhost:3000/login"
@export var sign_up_url := "http://localhost:3000/users"


func login_http_request(username: String, password: String) -> HumanHTTPResult:
	var dict := {"username": username, "password": password}
	var json_str: String = JSON.stringify(dict)

	var http_resource := HTTPRequestResource.new()
	http_resource.url = log_in_url
	http_resource.method = HTTPClient.METHOD_POST
	http_resource.request_data = json_str

	print_rich("[color=orange]AuthorizationHTTP:[/color] отправка запроса на авторизацию")
	var human_res: HumanHTTPResult = await _simplified_http_request(http_resource)
	return human_res


func sign_up_http_request(username: String, email: String, password: String) -> HumanHTTPResult:
	var dict := {"username": username, "email": email, "password": password}
	var json_str: String = JSON.stringify(dict)

	var http_resource := HTTPRequestResource.new()
	http_resource.url = sign_up_url
	http_resource.method = HTTPClient.METHOD_POST
	http_resource.request_data = json_str

	print_rich("[color=orange]AuthorizationHTTP:[/color] отправка запроса на регистрацию")
	var human_res: HumanHTTPResult = await _simplified_http_request(http_resource)
	return human_res


# Ещё более упрощённый http-запрос. Результатом являеться либо ошибка + сообщение
# ошибки, либо отсутствие ошибки + какое-то другое сообщение от сервера.
func _simplified_http_request(http_resource: HTTPRequestResource) -> HumanHTTPResult:
	var res: HTTPResult = await self.send_request(http_resource)
	print_rich("[color=orange]AuthorizationHTTP:[/color] заголовок полученного запроса: ", res.headers)

	var human_res := HumanHTTPResult.new()
	if not res.is_success():
		human_res.is_error = true
		# gdlint: disable=max-line-length
		human_res.message = "Error code: " + str(res.get_error()) + "; http result code: " + str(res.get_result_code())
		return human_res

	# gdlint: disable=max-line-length
	print_rich("[color=orange]AuthorizationHTTP:[/color] тело полученного запроса в строковом виде: ", res.body_as_string())
	var res_body: Dictionary = res.body_as_json()
	if res.is_response_error():
		human_res.is_error = true
		var str_error: String
		if res_body.has("error"):
			str_error = res_body.get("error")
		else:
			str_error = "Response error: " + str(res.response_code)
		human_res.message = str_error
		return human_res

	if res_body.has("message"):
		human_res.message = res_body.get("message")

	return human_res
