extends Node2D

# TileMapLayer
var tilemap: TileMapLayer

func _ready() -> void:
	tilemap = $TileMapLayer

func is_available(tile_coords: Vector2i) -> bool:
	var tile_data = tilemap.get_cell_tile_data(tile_coords)
	return tile_data and tile_data.get_custom_data("isAvailable")
	
# Обновление позиции игрока на карте
func update_player_position(old_coords: Vector2i, new_coords: Vector2i):
	pass 
