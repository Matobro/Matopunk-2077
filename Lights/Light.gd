extends Node2D

@export var start_angle: float = 0.0
@export var end_angle: float = 45
@export var duration: float = 10.0

func _ready() -> void:
	rotation = start_angle
	
	var tween = create_tween().set_loops()  # infinite loops
	# rotate forward
	tween.tween_property(self, "rotation_degrees", end_angle, duration).from(start_angle).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# rotate back
	tween.tween_property(self, "rotation_degrees", start_angle, duration).from(end_angle).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
