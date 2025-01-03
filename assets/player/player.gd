extends Node2D

# Направления движения (всего 6, для гексагональной сетки)
enum FacingDirection { NORTH_EAST, EAST, SOUTH_EAST, SOUTH_WEST, WEST, NORTH_WEST }

@export var map: Node = null  # Ссылка на объект карты
@export var start_position: Vector2i = Vector2i(0, 0)
@export var start_facing_direction: FacingDirection = FacingDirection.EAST
@export var bullet_scene: PackedScene
@export var health: int = 3
@export var id: int = -1
var position_in_tiles: Vector2i  # Координаты тайла, в котором находится юнит
var facing_direction: FacingDirection = FacingDirection.EAST  # Текущее направление юнита


func _ready() -> void:
	set_position_in_tiles(start_position)
	set_facing_direction(start_facing_direction)


func set_map(game_map: Node):
	map = game_map


func set_id(player_id: int):
	id = player_id


func set_sprite(sprite: CompressedTexture2D):
	$Sprite2D.texture = sprite


func get_position_in_tiles() -> Vector2i:
	return position_in_tiles


# Помещение игрока в указанный тайл. Возвращает true, если персонаж переместился
func set_position_in_tiles(tile_coords: Vector2i) -> bool:
	if not map:
		push_error("Map is not set. Use set_map() to assign it.")
		return false

	if map.is_available(tile_coords) and not map.is_position_occupied(tile_coords):
		map.update_player_position(self, tile_coords)
		position_in_tiles = tile_coords
		position = PosGetter.calculate_world_position(tile_coords)
		return true
	return false


func get_facing_direction() -> FacingDirection:
	return facing_direction


func set_facing_direction(new_direction: FacingDirection):
	facing_direction = new_direction
	rotation = 0
	match facing_direction:
		FacingDirection.NORTH_EAST:
			rotate(-PI / 3)
		FacingDirection.EAST:
			rotate(0)
		FacingDirection.SOUTH_EAST:
			rotate(PI / 3)
		FacingDirection.SOUTH_WEST:
			rotate(PI * 2 / 3)
		FacingDirection.WEST:
			rotate(PI)
		FacingDirection.NORTH_WEST:
			rotate(-PI * 2 / 3)
		_:
			pass


# Поворот игрока влево(false)/вправо(true)
func rotate_unit(clockwise: bool):
	var offset = 1 if clockwise else -1
	facing_direction = (offset + facing_direction) % 6
	rotate(PI / 3 * offset)


# Шаг вперёд. Возвращает true, если переместился
func move_forward() -> bool:
	var direction_offset = _get_direction_offset()
	var target_tile = position_in_tiles + direction_offset
	return set_position_in_tiles(target_tile)


# возвращает смещение для каждого направления
func _get_direction_offset() -> Vector2i:
	# Определяем, нечётная ли строка, от чего зависит смещение
	var is_odd_row = position_in_tiles.y % 2 != 0
	var res = Vector2i(0, 0)
	match facing_direction:
		FacingDirection.NORTH_EAST:
			res = Vector2i(1, -1) if is_odd_row else Vector2i(0, -1)
		FacingDirection.EAST:
			res = Vector2i(1, 0)
		FacingDirection.SOUTH_EAST:
			res = Vector2i(1, 1) if is_odd_row else Vector2i(0, 1)
		FacingDirection.SOUTH_WEST:
			res = Vector2i(0, 1) if is_odd_row else Vector2i(-1, 1)
		FacingDirection.WEST:
			res = Vector2i(-1, 0)
		FacingDirection.NORTH_WEST:
			res = Vector2i(0, -1) if is_odd_row else Vector2i(-1, -1)
		_:
			res = Vector2i(0, 0)
	return res


func shoot(is_test: bool):
	if not bullet_scene:
		push_error("Bullet scene is not set.")
		return null
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.setup(map, position_in_tiles, facing_direction)
	if not is_test:
		bullet.move()
	return bullet


func take_damage(amount: int) -> void:
	health -= amount
	Labels.health_changed.emit(id, health)
	if health <= 0:
		die()


func die() -> void:
	print("Player has died!")
	map.remove_player(self)
	Labels.death.emit(id)
	queue_free()
