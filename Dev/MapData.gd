extends Node2D

class_name MapData

@export_category("Map Data")
@export var stairs_layer: TileMapLayer
@export var stairs_collision_layer: int
@export var stair_entrance_tiles: Array[Vector2i]

func get_stairs_map() -> TileMapLayer:
    return stairs_layer


func get_stairs_layer() -> int:
    return stairs_collision_layer


func get_stairs_entrance_tiles() -> Array[Vector2i]:
    return stair_entrance_tiles
