@icon("res://addons/EditorIcons/hearts.svg")
class_name HealthComponent
extends Node

@export var buff_manager:FlowerBuffManager
@export var target:Node2D

var data:CharacterData

func _ready() -> void:
    data = buff_manager.compute_data as CharacterData
    data.hp_is_zero.connect(func():target.die())

func damage(_value:float) -> void:
    data.hp -= _value
