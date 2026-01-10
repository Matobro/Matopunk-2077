extends AnimatedSprite2D
class_name FX

@onready var light: Light2D = $PointLight2D

func _ready() -> void:
	play_fx()
	
func play_fx():
	play("fx")
	animation_finished.connect(done_playing)
	await get_tree().create_timer(0.04).timeout
	light.visible = false

func done_playing():
	queue_free()
