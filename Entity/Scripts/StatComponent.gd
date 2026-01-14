extends Node

class_name StatComponent


@export var debug_stats: Stats
var stats: Stats

signal current_health_changed(new_current: int)
signal max_health_changed(new_max: int)
signal died()


func _ready():
	stats = debug_stats.duplicate(true)
	stats.initialize()
	for i in range(10):
		await get_tree().physics_frame
	emit_signal("current_health_changed", get_health())
	emit_signal("max_health_changed", get_max_health())


func take_damage(amount: int) -> int:
	if amount <= 0:
		return stats.get_current(StatKeys.HEALTH)

	var old_hp := stats.get_current(StatKeys.HEALTH)
	if old_hp <= 0:
		return stats.get_current(StatKeys.HEALTH)

	stats.change_current(StatKeys.HEALTH, -amount)

	var new_hp := stats.get_current(StatKeys.HEALTH)
	emit_signal("current_health_changed", new_hp)

	if new_hp <= 0:
		emit_signal("died")

	return stats.get_current(StatKeys.HEALTH)


func heal(amount: int) -> void:
	if amount <= 0:
		return

	var old_hp := stats.get_current(StatKeys.HEALTH)
	if old_hp <= 0:
		return

	stats.change_current(StatKeys.HEALTH, amount)

	var new_hp := stats.get_current(StatKeys.HEALTH)
	emit_signal("current_health_changed", new_hp)


func get_health() -> int:
	return stats.get_current(StatKeys.HEALTH)


func get_max_health() -> int:
	return stats.get_final(StatKeys.MAX_HEALTH)


func add_stat_modifier(stat: String, value: int):
	stats.add_modifier(stat, value)

	if stat == StatKeys.MAX_HEALTH:
		emit_signal("max_health_changed", get_max_health())