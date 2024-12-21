extends GutTest

const FACING_DIRECTION = preload("res://assets/player/player.gd").FacingDirection
var Player = load("res://assets/player/Player.tscn")
var Map = load("res://scenes/game_map/GameMap.tscn")
var Bullet = load("res://assets/bullet/Bullet.tscn")

var map = null


func before_each():
	map = Map.instantiate()
	add_child(map)


func test_bullet_travel():
	var player = Player.instantiate()
	add_child(player)
	player.set_map(map)

	player.set_position_in_tiles(Vector2i(4, 5))
	player.set_facing_direction(FACING_DIRECTION.WEST)

	var bullet = player.shoot(true)
	assert_not_null(bullet)
	assert_eq(bullet.get_position_in_tiles(), Vector2i(4, 5))
	bullet.move_forward()
	assert_eq(bullet.get_position_in_tiles(), Vector2i(3, 5))
	bullet.move_forward()
	assert_eq(bullet.get_position_in_tiles(), Vector2i(2, 5))
	bullet.move_forward()
	assert_eq(bullet.get_position_in_tiles(), Vector2i(1, 5))


func test_bullet_collision_with_obstacle():
	var player = Player.instantiate()
	add_child(player)
	player.set_map(map)

	player.set_position_in_tiles(Vector2i(4, 5))
	player.set_facing_direction(FACING_DIRECTION.EAST)

	var bullet = player.shoot(true)
	assert_not_null(bullet)
	bullet.move_forward()


func test_bullet_hits_player():
	var player1 = Player.instantiate()
	var player2 = Player.instantiate()
	add_child(player1)
	add_child(player2)
	player1.set_map(map)
	player2.set_map(map)
	player1.set_position_in_tiles(Vector2i(0, 0))
	player2.set_position_in_tiles(Vector2i(3, 0))
	player1.set_facing_direction(FACING_DIRECTION.EAST)

	var bullet = player1.shoot(true)
	assert_not_null(bullet)
	bullet.move_forward()
	bullet.move_forward()
	bullet.move_forward()
	assert_eq(player2.health, 2)
