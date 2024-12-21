extends Node2D

# TileMapLayer
var tilemap: TileMapLayer
var player_positions: Dictionary = {}


func _ready() -> void:
	tilemap = $TileMapLayer


func is_available(tile_coords: Vector2i) -> bool:
	var tile_data = tilemap.get_cell_tile_data(tile_coords)
	return tile_data and tile_data.get_custom_data("isAvailable")


func is_passable(tile_coords: Vector2i) -> bool:
	var tile_data = tilemap.get_cell_tile_data(tile_coords)
	return tile_data and tile_data.get_custom_data("isPassable")


func update_player_position(player: Node, new_position: Vector2i) -> void:
	player_positions[player.get_path()] = new_position


func get_player_at_position(position: Vector2i) -> Node:
	for path in player_positions:
		if player_positions[path] == position:
			return get_node(path)
	return null


func is_position_occupied(position: Vector2i) -> bool:
	return get_player_at_position(position) != null


func damage_player(tile_coords: Vector2i, damage: int) -> void:
	var player = get_player_at_position(tile_coords)
	player.take_damage(damage)


func remove_player(player: Node) -> void:
	var path = player.get_path()
	if player_positions.has(path):
		player_positions.erase(path)
		print("Player removed from map: ", path)
	else:
		print("Player not found on map: ", path)
