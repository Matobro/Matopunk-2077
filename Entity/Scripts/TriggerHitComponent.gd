extends Area2D

class_name TriggerHitComponent

signal stairs_entered()
signal stairs_exited()

var touching_stairs_amount: int = 0

func _ready() -> void:
	area_entered.connect(on_area_enter)
	area_exited.connect(on_area_exit)


func on_area_enter(area: Area2D):
	if area.is_in_group("stairs"):
		touching_stairs_amount += 1
		if touching_stairs_amount == 1:
			emit_signal("stairs_entered")


func on_area_exit(area: Area2D):
	if area.is_in_group("stairs"):
		touching_stairs_amount -= 1
		if touching_stairs_amount <= 0:
			touching_stairs_amount = 0
			emit_signal("stairs_exited")