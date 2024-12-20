extends GutTest

var Player = load("res://assets/player/Player.tscn")
var Map = load("res://scenes/game_map/GameMap.tscn")
const Face_Dir = preload("res://assets/player/Player.gd").FacingDirection
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
	player.facing_direction = Face_Dir.NORTH_EAST
	assert_eq(player.get_facing_direction(), Face_Dir.NORTH_EAST)
	player.rotate_unit(true)
	assert_eq(player.get_facing_direction(), Face_Dir.EAST)
	player.rotate_unit(false)
	assert_eq(player.get_facing_direction(), Face_Dir.NORTH_EAST)
	
	player.rotate_unit(true)
	player.rotate_unit(true)
	player.rotate_unit(true)
	assert_eq(player.get_facing_direction(), Face_Dir.SOUTH_WEST)
	

func test_move_forward():
	var player = Player.instantiate()
	player.set_map(map)

	player.set_position_in_tiles(Vector2i(6, 3))
	player.set_facing_direction(Face_Dir.EAST)
	player.move_forward()
	assert_eq(player.get_position_in_tiles(), Vector2i(7, 3))
	player.set_facing_direction(Face_Dir.WEST)
	player.move_forward()
	player.move_forward()
	player.set_position_in_tiles(Vector2i(6, 3))
	
	player.set_position_in_tiles(Vector2i(0, 0))
	player.set_facing_direction(Face_Dir.WEST)
	assert_false(player.move_forward())
	assert_eq(player.get_position_in_tiles(), Vector2i(0, 0))
	
