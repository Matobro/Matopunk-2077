extends Resource
class_name Stats

@export_category("Base Stats")
@export var HEALTH: int = 50
@export var MAXHEALTH: int = 50

@export var current_map: Dictionary = {
	"HEALTH": "MAXHEALTH"
}

var stat_names := ["HEALTH","MAXHEALTH"]

# current stats
var current: Dictionary = {}

# buffs/debuffs for each stat
var modifiers: Dictionary = {}


func initialize():
	for current_stat in current_map.keys():
		var max_stat = current_map[current_stat]
		current[current_stat] = get_stat(max_stat)


func get_stat(name: String) -> int:
	if name in stat_names:
		return get(name)
	return 0


func set_stat(name: String, value: int):
	if name in stat_names:
		set(name, value)


func get_current(name: String) -> int:
	return current.get(name, 0)


func get_final(name: String) -> int:
	return get_current(name) + modifiers.get(name, 0)


func add_modifier(name: String, amount: int):
	modifiers[name] = modifiers.get(name, 0) + amount
	clamp_current(name)


func clamp_current(current_stat: String):
	var max_stat = current_map.get(current_stat, null)
	if max_stat == null:
		return
	current[current_stat] = clamp(
		current[current_stat],
		0,
		get_final(max_stat)
	)
