extends Node2D

const FACING_DIRECTION = preload("res://assets/player/player.gd").FacingDirection

@export var move_range: int = 3
@export var damage: int = 1
var map: Node = null
var current_position: Vector2i
var facing_direction: FACING_DIRECTION
var steps: int
var is_destroyed: bool = false


func setup(game_map: Node, start_position: Vector2i, direction: FACING_DIRECTION):
	map = game_map
	current_position = start_position
	facing_direction = direction
	set_facing_direction()
	_position_update()


func get_position_in_tiles() -> Vector2i:
	return current_position


func set_facing_direction():
	match facing_direction:
		FACING_DIRECTION.NORTH_EAST:
			rotate(-PI / 3)
		FACING_DIRECTION.EAST:
			rotate(0)
		FACING_DIRECTION.SOUTH_EAST:
			rotate(PI / 3)
		FACING_DIRECTION.SOUTH_WEST:
			rotate(PI * 2 / 3)
		FACING_DIRECTION.WEST:
			rotate(PI)
		FACING_DIRECTION.NORTH_WEST:
			rotate(-PI * 2 / 3)
		_:
			pass


func move():
	$Timer.start()


func move_forward() -> bool:
	var offset = _get_direction_offset()
	var next_position = current_position + offset

	if not map.is_passable(next_position):
		return false

	current_position = next_position

	if map.is_position_occupied(next_position):
		map.damage_player(next_position, damage)
		return false

	steps += 1
	_position_update()

	if steps == 3:
		return false
	return true


func _position_update():
	position = PosGetter.calculate_world_position(current_position)


func _get_direction_offset() -> Vector2i:
	# Определяем, нечётная ли строка, от чего зависит смещение
	var is_odd_row = current_position.y % 2 != 0
	var res = Vector2i(0, 0)
	match facing_direction:
		FACING_DIRECTION.NORTH_EAST:
			res = Vector2i(1, -1) if is_odd_row else Vector2i(0, -1)
		FACING_DIRECTION.EAST:
			res = Vector2i(1, 0)
		FACING_DIRECTION.SOUTH_EAST:
			res = Vector2i(1, 1) if is_odd_row else Vector2i(0, 1)
		FACING_DIRECTION.SOUTH_WEST:
			res = Vector2i(0, 1) if is_odd_row else Vector2i(-1, 1)
		FACING_DIRECTION.WEST:
			res = Vector2i(-1, 0)
		FACING_DIRECTION.NORTH_WEST:
			res = Vector2i(0, -1) if is_odd_row else Vector2i(-1, -1)
		_:
			res = Vector2i(0, 0)
	return res


func _on_timer_timeout() -> void:
	if not move_forward():
		is_destroyed = true
	if is_destroyed:
		$Destroy_timer.start()
	else:
		$Timer.start()


func _on_destroy_timer_timeout() -> void:
	queue_free()
