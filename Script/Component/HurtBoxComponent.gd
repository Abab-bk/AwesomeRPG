class_name HurtBoxComponent
extends Area2D

@export var health_component:HealthComponent

func handle_hit(_value:int) -> void:
    health_component.damage(_value)
