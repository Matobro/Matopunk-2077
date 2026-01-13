extends Resource
class_name Stats

@export_category("Base Stats")
@export var HEALTH: int = 50
@export var MAX_HEALTH: int = 50

var _base := {}
var _current := {}
var _modifiers := {}


func initialize():
	_base.clear()
	_current.clear()
	_modifiers.clear()

	for prop in get_property_list():
		if prop.usage & PROPERTY_USAGE_EDITOR == 0:
			continue

		if prop.name == prop.name.to_upper():
			var value = get(prop.name)
			_base[prop.name] = value
			_current[prop.name] = value
			_modifiers[prop.name] = 0


func get_stat(stat: String) -> int:
	return _base.get(stat, 0)


func get_current(stat: String) -> int:
	return _current.get(stat, 0)


func get_final(stat: String) -> int:
	return get_current(stat) + _modifiers.get(stat, 0)


func set_current(stat: String, value: int):
	if not stat in _current:
		return
	_current[stat] = value
	_clamp(stat)


func change_current(stat: String, delta: int):
	set_current(stat, get_current(stat) + delta)


func add_modifier(stat: String, value: int):
	_modifiers[stat] += value
	_clamp(stat)


func _clamp(stat: String):
	var max_key := "MAX_" + stat
	if max_key in _base:
		_current[stat] = clamp(
			_current[stat],
			0,
			get_final(max_key)
		)