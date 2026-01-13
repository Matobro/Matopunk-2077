extends Node

class_name StatComponent


@export var debug_stats: Stats
var stats: Stats

signal health_changed(old_value: int, new_value: int)
signal died()


func _ready():
	stats = debug_stats.duplicate(true)
	stats.initialize()


func take_damage(amount: int) -> void:
	if amount <= 0:
		return

	var old_hp := stats.get_current(StatKeys.HEALTH)
	if old_hp <= 0:
		return

	stats.change_current(StatKeys.HEALTH, -amount)

	var new_hp := stats.get_current(StatKeys.HEALTH)
	emit_signal("health_changed", old_hp, new_hp)

	if new_hp <= 0:
		emit_signal("died")

	print(old_hp, " -> ", new_hp)


func heal(amount: int) -> void:
	if amount <= 0:
		return

	var old_hp := stats.get_current(StatKeys.HEALTH)
	if old_hp <= 0:
		return

	stats.change_current(StatKeys.HEALTH, amount)

	var new_hp := stats.get_current(StatKeys.HEALTH)
	emit_signal("health_changed", old_hp, new_hp)


func get_health() -> int:
	return stats.get_current(StatKeys.HEALTH)


func get_max_health() -> int:
	return stats.get_final(StatKeys.MAX_HEALTH)
