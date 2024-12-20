extends Node2D

# Направления движения (всего 6, для гексагональной сетки)
enum FacingDirection { NORTH_EAST, EAST, SOUTH_EAST, SOUTH_WEST, WEST, NORTH_WEST }

# Поля юнита
@export var map: Node = null  # Ссылка на объект карты
var position_in_tiles: Vector2i  # Координаты тайла, в котором находится юнит
var facing_direction: FacingDirection = FacingDirection.EAST  # Текущее направление юнита
@export var start_position: Vector2i = Vector2i(0,0)
@export var start_facing_direction: FacingDirection = FacingDirection.EAST

func _ready() -> void:
	set_position_in_tiles(start_position)
	set_facing_direction(start_facing_direction)
	Buttons.turn_left_pressed.connect(rotate_unit)
	Buttons.turn_right_pressed.connect(rotate_unit)
	Buttons.move_pressed.connect(move_forward)
	

# Установка ссылки на карту
func set_map(game_map: Node):
	map = game_map

# Получение позиции игрока в координатах тайлов
func get_position_in_tiles() -> Vector2i:
	return position_in_tiles

# Помещение игрока в указанный тайл. Возвращает true, если персонаж переместился
func set_position_in_tiles(tile_coords: Vector2i) -> bool:
	if not map:
		push_error("Map is not set. Use set_map() to assign it.")
		return false

	if map.is_available(tile_coords):
		#map.update_player_position(position_in_tiles, tile_coords)  # Обновляем карту
		position_in_tiles = tile_coords
		position = PosGetter.calculate_world_position(tile_coords)  # Обновляем мировую позицию
		return true
	else:
		print("no")
		return false

# Получение текущего направления юнита
func get_facing_direction() -> FacingDirection:
	return facing_direction

# Изменение направления юнита
func set_facing_direction(new_direction: FacingDirection):
	facing_direction = new_direction
	match facing_direction:
		FacingDirection.NORTH_EAST: rotate(-PI / 3)
		FacingDirection.EAST: rotate(0)
		FacingDirection.SOUTH_EAST: rotate(PI / 3)
		FacingDirection.SOUTH_WEST: rotate(PI * 2 / 3)
		FacingDirection.WEST: rotate(PI)
		FacingDirection.NORTH_WEST: rotate(-PI * 2 / 3)
		_: pass

# Поворот игрока влево/вправо
func rotate_unit(clockwise: bool):
	var offset = 1 if clockwise else -1
	facing_direction += offset
	rotate(PI / 3 * -offset )

# Шаг вперёд. Возвращает true, если переместился
func move_forward()-> bool:
	var direction_offset = _get_direction_offset(facing_direction)
	var target_tile = position_in_tiles + direction_offset
	
	return set_position_in_tiles(target_tile) # Обновляем мировую позицию

# Приватная функция: возвращает смещение для каждого направления
func _get_direction_offset(direction: FacingDirection) -> Vector2i:
	match direction:
		FacingDirection.NORTH_EAST: return Vector2i(1, -1)
		FacingDirection.EAST: return Vector2i(1, 0)
		FacingDirection.SOUTH_EAST: return Vector2i(0, 1)
		FacingDirection.SOUTH_WEST: return Vector2i(-1, 1)
		FacingDirection.WEST: return Vector2i(-1, 0)
		FacingDirection.NORTH_WEST: return Vector2i(0, -1)
		_: return Vector2i(0, 0)
