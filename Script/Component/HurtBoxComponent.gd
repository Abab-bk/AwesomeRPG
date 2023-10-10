class_name HurtBoxComponent
extends Area2D

@export var health_component:HealthComponent

func _ready() -> void:
    set_collision_layer_value(2, true)

func handle_hit(_value:int) -> void:
    health_component.damage(_value)
    EventBus.update_ui.emit()
