extends Node2D

const TILE_SIZE = 20
const V_OFFSET = TILE_SIZE * 0.75
const OFFSET_COORD: Vector2 = Vector2(61, 43)


func calculate_hex_position(pos: Vector2i):
	var pos_x = pos.x * TILE_SIZE
	var pos_y = pos.y * V_OFFSET
	if pos.y % 2 == 1:
		pos_x += TILE_SIZE / 2
	return Vector2(pos_x, pos_y)


func calculate_world_position(pos: Vector2i):
	return calculate_hex_position(pos) + OFFSET_COORD
