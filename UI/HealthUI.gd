extends Control

class_name HealthUI


@onready var health_bar: Slider = $HealthBar
@onready var health_current_label: Label = $HpCurrent
@onready var health_max_label: Label = $HpMax


func update_current_health(value: int):
    health_current_label.text = str(value)
    health_bar.value = value


func update_max_health(value: int):
    health_max_label.text = str(value)
    health_bar.max_value = value


