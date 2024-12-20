extends Node2D

const Player = preload("res://assets/player/Player.tscn")

# TileMapLayer
var tilemap: TileMapLayer

func _ready() -> void:
	tilemap = $TileMapLayer
	
func _get_tiledata_by_tile_coords(tile_coords: Vector2i):
	var pos = PosGetter.calculate_hex_position(tile_coords)
	#return tilemap.get_cell_tile_data(pos)
	return tilemap.get_cell_tile_data(tilemap.local_to_map(pos) + Vector2i(1, 1))
	#var player = Player.instantiate()
	#add_child(player)
	#player.position = tilemap.local_to_map(pos) + Vector2i(1, 1)
	return tilemap.get_cell_tile_data(tile_coords + Vector2i(1, 1))

func is_available(tile_coords: Vector2i) -> bool:
	var tile_data = _get_tiledata_by_tile_coords(tile_coords)
	return tile_data and tile_data.get_custom_data("isAvailable")
	
# Обновление позиции игрока на карте
func update_player_position(old_coords: Vector2i, new_coords: Vector2i):
	#var tile_data_old = _get_tiledata_by_tile_coords(old_coords)
	var tile_data_old = tilemap.get_cell_tile_data(old_coords)
	if tile_data_old:
		tile_data_old.set_custom_data("isPlayerHere", false)  # Убираем игрока с предыдущего тайла
	else:
		print('a')
	var tile_data_new = tilemap.get_cell_tile_data(new_coords)
	#var tile_data_new = _get_tiledata_by_tile_coords(new_coords)
	if tile_data_new:
		tile_data_new.set_custom_data("isPlayerHere", true)  # Устанавливаем игрока на новом тайле
	else:
		print('b')     
