@icon("res://addons/EditorIcons/hearts.svg")
class_name HealthComponent
extends Node

@export var buff_manager:FlowerBuffManager
@export var target:Node2D

var data:CharacterData

func _ready() -> void:
    buff_manager.compute_ok.connect(func():
        data = buff_manager.output_data    
        )
    data = buff_manager.output_data

func damage(_value:float) -> void:
    data.hp -= _value
