@icon("res://addons/EditorIcons/hearts.svg")
class_name HealthComponent
extends Node

@export var buff_manager:FlowerBuffManager

func damage(_value:int) -> void:
    buff_manager.compute_data.hp -= _value
