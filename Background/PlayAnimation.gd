extends AnimatedSprite2D

@export var animation_name: String = ""
@export var loop: bool = false

func _ready() -> void:
    sprite_frames.set_animation_loop(animation_name, loop)
    play(animation_name)