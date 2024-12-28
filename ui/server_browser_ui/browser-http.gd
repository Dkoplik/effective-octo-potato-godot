class_name BrowserHTTP
extends AwaitableHTTP

@export var server_list_url := "http://localhost:3000/lobbies"
@export var connect_to_server_url := ""


func login_http_request(username: String, password: String) -> HumanHTTPResult:
	var dict := {"username": username, "password": password}  #TODO
	var json_str: String = JSON.stringify(dict)  # TODO

	var http_resource := HTTPRequestResource.new()
	http_resource.url = connect_to_server_url
	http_resource.custom_headers = ["Content-Type: application/json"]
	http_resource.method = HTTPClient.METHOD_POST
	http_resource.request_data = json_str

	print_rich("[color=orange]BrowserHTTP:[/color] отправка запроса на подключение к серверу")
	var human_res: HumanHTTPResult = await _simplified_http_request(http_resource)
	return human_res


func get_server_list_request() -> HumanHTTPResult:
	var http_resource := HTTPRequestResource.new()
	http_resource.url = server_list_url
	http_resource.method = HTTPClient.METHOD_GET

	print_rich("[color=orange]BrowserHTTP:[/color] отправка запроса на список серверов")
	var human_res: HumanHTTPResult = await _simplified_http_request(http_resource)
	return human_res


# Ещё более упрощённый http-запрос. Результатом являеться либо ошибка + сообщение
# ошибки, либо отсутствие ошибки + какое-то другое сообщение от сервера.
func _simplified_http_request(http_resource: HTTPRequestResource) -> HumanHTTPResult:
	var res: HTTPResult = await self.send_request(http_resource)
	print_rich("[color=orange]BrowserHTTP:[/color] заголовок полученного запроса: ", res.headers)

	var human_res := HumanHTTPResult.new()
	if not res.is_success():
		human_res.is_error = true
		# gdlint: disable=max-line-length
		human_res.message = (
			"Error code: "
			+ str(res.get_error())
			+ "; http result code: "
			+ str(res.get_result_code())
		)
		return human_res

	if res.headers.get("content-type") != "application/json; charset=utf-8":
		push_error("Получен не JSON")
		human_res.is_error = true
		human_res.message = "Error: ответ не в JSON-формате"
		return human_res

	# gdlint: disable=max-line-length
	print_rich(
		"[color=orange]BrowserHTTP:[/color] тело полученного запроса в строковом виде: ",
		res.body_as_string()
	)
	var res_body: Dictionary = res.body_as_json()
	if res.is_response_error():
		human_res.is_error = true
		var str_error: String
		if res_body.has("error"):
			str_error = res_body.get("error")
		elif res_body.has("errors"):
			str_error = "; ".join(res_body.get("errors"))
		else:
			str_error = "Response error: " + str(res.response_code)
		human_res.message = str_error
		return human_res

	if res_body.has("message"):
		human_res.message = res_body.get("message")

	return human_res
