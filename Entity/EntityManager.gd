extends Node

var enemy_prefab: PackedScene = preload("res://Enemies/Enemy.tscn")
var player_prefab: PackedScene = preload("res://Player/Player.tscn")

var enemies: Array[Enemy]
var players: Array[Player]


func register_enemy(enemy: Enemy):
    enemies.append(enemy)


func remove_enemy(enemy: Enemy):
    if enemy in enemies:
        enemies.erase(enemy)

    
func register_player(player: Player):
    players.append(player)


func remove_player(player: Player):
    if player in players:
        players.append(player)


func get_all_players():
    return players