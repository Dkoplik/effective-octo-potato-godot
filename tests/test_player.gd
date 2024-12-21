extends GutTest

const Player = preload("res://assets/player/Player.tscn")
const Map = preload("res://scenes/game_map/GameMap.tscn")
const FACE_DIRECTION = preload("res://assets/player/Player.gd").FacingDirection
var map = null

func before_each():
	map = Map.instantiate()
	add_child(map)

func test_get_position_in_tiles():
	var player = Player.instantiate()
	player.position_in_tiles = Vector2i(4, 5)
	assert_eq(player.get_position_in_tiles(), Vector2i(4, 5))

func test_set_position_in_tiles():
	var player = Player.instantiate()
	player.set_map(map)

	assert_true(map.is_available(Vector2i(4, 5)))
	assert_true(player.set_position_in_tiles(Vector2i(4, 5)))
	assert_eq(player.get_position_in_tiles(), Vector2i(4, 5))
	assert_false(player.set_position_in_tiles(Vector2i(5, 5)))


func test_rotate():
	var player = Player.instantiate()
	player.facing_direction = FACE_DIRECTION.NORTH_EAST
	assert_eq(player.get_facing_direction(), FACE_DIRECTION.NORTH_EAST)
	player.rotate_unit(true)
	assert_eq(player.get_facing_direction(), FACE_DIRECTION.EAST)
	player.rotate_unit(false)
	assert_eq(player.get_facing_direction(), FACE_DIRECTION.NORTH_EAST)

func test_rotate_180():
	var player = Player.instantiate()
	player.facing_direction = FACE_DIRECTION.NORTH_EAST
	player.rotate_unit(true)
	player.rotate_unit(true)
	player.rotate_unit(true)
	assert_eq(player.get_facing_direction(), FACE_DIRECTION.SOUTH_WEST)

func test_move_forward():
	var player = Player.instantiate()
	player.set_map(map)

	player.set_position_in_tiles(Vector2i(6, 3))
	player.set_facing_direction(FACE_DIRECTION.EAST)
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(7, 3))
	player.set_facing_direction(FACE_DIRECTION.WEST)
	player.move_forward()
	player.move_forward() # Движение в препятствие
	assert_eq(player.get_position_in_tiles(), Vector2i(6, 3))

func test_move_forward_into_wall():
	var player = Player.instantiate()
	player.set_map(map)
	player.set_position_in_tiles(Vector2i(0, 0))
	player.set_facing_direction(FACE_DIRECTION.WEST)
	assert_false(player.move_forward())
	assert_eq(player.get_position_in_tiles(), Vector2i(0, 0))

func test_move_forward_se():
	var player = Player.instantiate()
	player.set_map(map)
	player.set_position_in_tiles(Vector2i(3, 3))
	player.set_facing_direction(FACE_DIRECTION.SOUTH_EAST)
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(4, 4))
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(4, 5))

func test_move_forward_sw():
	var player = Player.instantiate()
	player.set_map(map)
	player.set_position_in_tiles(Vector2i(2, 4))
	player.set_facing_direction(FACE_DIRECTION.SOUTH_WEST)
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(1, 5))
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(1, 6))

func test_move_forward_ne():
	var player = Player.instantiate()
	player.set_map(map)
	player.set_position_in_tiles(Vector2i(3, 3))
	player.set_facing_direction(FACE_DIRECTION.NORTH_EAST)
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(4, 2))
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(4, 1))

func test_move_forward_nw():
	var player = Player.instantiate()
	player.set_map(map)
	player.set_position_in_tiles(Vector2i(3, 3))
	player.set_facing_direction(FACE_DIRECTION.NORTH_WEST)
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(3, 2))
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(2, 1))
