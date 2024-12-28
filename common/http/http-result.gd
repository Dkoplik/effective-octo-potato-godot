class_name HTTPResult
extends RefCounted

var response_code: HTTPClient.ResponseCode = HTTPClient.RESPONSE_ACCEPTED
var headers: Dictionary
var body: PackedByteArray

var _error: Error = OK
var _result: HTTPRequest.Result


func is_success() -> bool:
	return _error == OK and _result == HTTPRequest.RESULT_SUCCESS


func get_error() -> Error:
	return _error


func get_result_code() -> HTTPRequest.Result:
	return _result


func is_response_ok() -> bool:
	return response_code >= 200 and response_code < 300


func is_response_error() -> bool:
	return is_response_client_error() or is_response_server_error()


func is_response_client_error() -> bool:
	return response_code >= 400 and response_code < 500


func is_response_server_error() -> bool:
	return response_code >= 500 and response_code < 600


func body_as_string() -> String:
	var body_str: String = body.get_string_from_utf8()
	if body_str.is_empty():
		push_error("Тело http запроса не является utf8-строкой")
	return body_str


func body_as_json() -> Variant:
	var body_json: Variant = JSON.parse_string(body_as_string())
	if body_json == null:
		push_error("Тело http запроса не является json'ом")
	return body_json


static func _from_error(error: Error) -> HTTPResult:
	var http_result := HTTPResult.new()
	http_result._error = error
	return http_result


static func _from_array(data_arr: Array) -> HTTPResult:
	#region проверка входных данных
	if data_arr.size() != 4:
		push_error("Некорректный размер массива для формирования HTTP результата")
	if data_arr[0] is not int:
		push_error("1-ый параметр должен быть целым числом")
	if data_arr[1] is not int:
		push_error("2-ой параметр должен быть целым числом")
	if data_arr[2] is not PackedStringArray:
		push_error("3-ий параметр должен быть массивом строк")
	if data_arr[3] is not PackedByteArray:
		push_error("4-ый параметр должен быть массивом байтов")
	#endregion

	var http_result := HTTPResult.new()
	http_result._error = OK
	@warning_ignore("unsafe_cast")
	http_result._result = data_arr[0] as HTTPRequest.Result
	@warning_ignore("unsafe_cast")
	http_result.response_code = data_arr[1] as HTTPClient.ResponseCode
	@warning_ignore("unsafe_cast")
	http_result.headers = _headers_to_dict(data_arr[2] as PackedStringArray)
	@warning_ignore("unsafe_cast")
	http_result.body = data_arr[3] as PackedByteArray
	return http_result


static func _headers_to_dict(headers_arr: PackedStringArray) -> Dictionary:
	var dict := {}
	for header: String in headers_arr:
		var split: PackedStringArray = header.split(":")
		dict[split[0].to_lower()] = split[1].strip_edges()

	return dict
