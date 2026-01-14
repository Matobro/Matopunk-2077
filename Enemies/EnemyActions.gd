extends Node

class_name EnemyActions

@export_category("Dependencies")
@export var sound_player: SoundPlayer


func reload_done(data: WeaponData, cancelled: bool = false):
	pass
	#sound_player.play_audio(data.reload)


func shot_fired(data: WeaponData):
	sound_player.play_audio(data.shoot)
