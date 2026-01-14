extends Node2D

class_name EnemyAI

signal set_movement_direction(direction: int)
signal set_aim_position(pos: Vector2)
signal call_shoot()


func initialize_ai(enemy: Enemy):
    pass


func run_ai(delta: float, enemy: Enemy):
    print("Enemy AI of ", enemy, " is invalid")


func target_spotted(player: Player):
    pass