extends Node
class_name PickUpComponent


func _ready() -> void:
    connect("area_entered", try_pick_up)

func try_pick_up(pick_up) -> Node:
    print(" trying")
    if pick_up.is_in_group("WeaponPickup"):
        print(" working")
        return pick_up
    return null