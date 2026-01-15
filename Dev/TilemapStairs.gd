extends TileMapLayer

@export var stair_area: PackedScene
@export var stair_left_tiles: Array[Vector2i]
@export var stair_right_tiles: Array[Vector2i]
@export var is_entrance: bool

func _ready() -> void:
	setup_stairs_area()


func setup_stairs_area():
	var stair_tiles: Array[Vector2i] = stair_left_tiles + stair_right_tiles
	for cell in get_used_cells():
		var tile_coords = get_cell_atlas_coords(cell)
		if tile_coords in stair_tiles:
			var area = stair_area.instantiate()
			var col = area.get_child(0)
			area.position = map_to_local(cell)
			if is_entrance and tile_coords in stair_left_tiles:
				col.rotation = 0.0
				area.position.y += 16
				area.position.x -= 30

			elif is_entrance and tile_coords in stair_right_tiles:
				col.rotation = 0.0
				area.position.y += 16
				area.position.x -= 5

			elif !is_entrance and tile_coords in stair_right_tiles:
				area.rotation = deg_to_rad(270)

			add_child(area)
