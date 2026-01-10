extends Node2D

@export var root: Node
var pos: Vector2

@export var distance_moved: float = 0
@export var move_duration: float = 0

func _ready() -> void:
	for i in 1:
		await get_tree().process_frame

	pos = Vector2(root.global_position.x, root.global_position.y - distance_moved)

	if !root: return

	var tween = create_tween().set_loops()  # infinite loops
	# move up
	tween.tween_property(root, "position", Vector2(pos.x, pos.y - distance_moved), move_duration).from(Vector2(pos.x, pos.y + distance_moved)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# move down
	tween.tween_property(root, "position", Vector2(pos.x, pos.y + distance_moved), move_duration).from(Vector2(pos.x, pos.y - distance_moved)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
