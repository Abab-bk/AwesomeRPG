@icon("res://addons/EditorIcons/hearts.svg")
class_name HealthComponent
extends Node

@export var buff_manager:FlowerBuffManager

var data:CharacterData

func _ready() -> void:
    data = buff_manager.compute_data as CharacterData
    data.hp_is_zero.connect(get_parent().die)

func damage(_value:int) -> void:
    data.hp -= _value
