extends Area2D

signal bullet_hit()


func _ready():
    area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
    if area.is_in_group("bullet"):
        emit_signal("bullet_hit")
        area.queue_free()