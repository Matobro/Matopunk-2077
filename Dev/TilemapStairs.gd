extends TileMapLayer

@export var stair_area: PackedScene
@export var stair_solid_tile_coords: Array[Vector2i]
@export var is_entrance: bool

func _ready() -> void:
	setup_stairs_area()


func setup_stairs_area():
	for cell in get_used_cells():
		if get_cell_atlas_coords(cell) in stair_solid_tile_coords:
			var area = stair_area.instantiate()
			var col = area.get_child(0)
			area.position = map_to_local(cell)
			if is_entrance:
				col.rotation = 0.0
				area.position.y += 16
			add_child(area)
