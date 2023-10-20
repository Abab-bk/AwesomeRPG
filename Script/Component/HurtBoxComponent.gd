class_name HurtBoxComponent
extends Area2D

signal hited(value:float)

@export var health_component:HealthComponent

func _ready() -> void:
    set_collision_layer_value(2, true)

func handle_hit(_value:float) -> void:
    health_component.damage(_value)
    EventBus.update_ui.emit()
    hited.emit(_value)
