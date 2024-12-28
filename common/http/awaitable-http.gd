class_name AwaitableHTTP
extends HTTPRequest

signal request_finished

var _is_requesting := false


func send_request(http_resource: HTTPRequestResource) -> HTTPResult:
	#region извлечение данных запроса
	var url: String = http_resource.url
	var custom_headers: PackedStringArray = http_resource.custom_headers
	var method: HTTPClient.Method = http_resource.method
	var request_data: String = http_resource.request_data
	#endregion

	# gdlint: disable=max-line-length
	print_rich("[color=orange]AwaitableHTTP:[/color] отправка http запроса по [color=purple]url: ", url, "[/color] с методом ", method)
	print_rich("[color=orange]AwaitableHTTP:[/color] тело http запроса: ", request_data)

	if _is_requesting:
		push_error("Этот HTTP узел уже в процессе обработки запроса")
		return HTTPResult._from_error(ERR_BUSY)

	_is_requesting = true
	var error: Error = self.request(url, custom_headers, method, request_data)
	if error:
		push_error("Возникла ошибка ", error_string(error), " во время http request'а")
		return HTTPResult._from_error(error)

	@warning_ignore("unsafe_cast")
	var res_arr := await self.request_completed as Array
	_is_requesting = false
	request_finished.emit()
	print_rich("[color=orange]AwaitableHTTP:[/color] получен ответ на запрос")

	return HTTPResult._from_array(res_arr)


func is_requesting() -> bool:
	return _is_requesting
