extends Camera2D

class_name PlayerCamera


var camera_shake_strength: float = 0
var camera_shake_fade: float = 0


func apply_camera_shake(strength, fade):
    camera_shake_strength += strength
    camera_shake_fade = fade


func _process(delta: float) -> void:
    if camera_shake_strength > 0:
        camera_shake_strength = lerpf(camera_shake_strength, 0, camera_shake_fade * delta)
        offset = random_shake_offset()


func random_shake_offset() -> Vector2:
    return Vector2(randf_range(-camera_shake_strength, camera_shake_strength), randf_range(-camera_shake_strength, camera_shake_strength)) 