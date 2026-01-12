extends Node

class_name StatComponent


@export var debug_stats: Stats
var stats: Stats

signal health_changed(old_value: int, new_value: int)
signal died()


func _ready():
	stats = debug_stats.duplicate(true)
	stats.initialize()


func take_damage(amount: int):
	var old_health = stats.get_current("HEALTH")
	if old_health <= 0:
		return

	stats.current["HEALTH"] = old_health - amount
	stats.clamp_current("health")

	emit_signal("health_changed", old_health, stats.get_current("HEALTH"))

	if stats.get_current("health") <= 0:
		emit_signal("died")


func heal(amount: int):
	var old_health = stats.get_current("HEALTH")
	if old_health <= 0:
		return

	stats.current["health"] = old_health + amount
	stats.clamp_current("HEALTH")

	emit_signal("health_changed", old_health, stats.get_current("HEALTH"))
