extends Light2D

@export var start_intensity: float = 2.0
@export var end_intensity: float = 1.5
@export var duration: float = 1.0
@export var type: Tween.TransitionType
@export var ease: Tween.EaseType

func _ready() -> void:
	energy = start_intensity
	
	var tween = create_tween().set_loops()
	tween.tween_property(self, "energy", end_intensity, duration).from(start_intensity).set_trans(type).set_ease(ease)
	tween.tween_property(self, "energy", start_intensity, duration).from(end_intensity).set_trans(type).set_ease(ease)
