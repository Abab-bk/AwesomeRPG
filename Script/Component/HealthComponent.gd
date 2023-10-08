class_name HealthComponent
extends Node

signal dead

@export var buff_manager:FlowerBuffManager

var hp:int:
    set(v):
        hp = v
        if hp <= 0:
            dead.emit()
        buff_manager.compute_data.hp = hp

func _ready() -> void:
    hp = buff_manager.compute_data.hp

func damage(_value:int) -> void:
    hp -= _value
