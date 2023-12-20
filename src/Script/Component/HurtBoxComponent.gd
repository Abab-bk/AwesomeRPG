class_name HurtBoxComponent
extends Area2D

signal hited(value:float, crit:bool)

@export var health_component:HealthComponent
@export var is_player_hitbox:bool

func _ready() -> void:
    collision_layer = 0
    
    if is_player_hitbox:
        set_collision_layer_value(6, true)
    else:
        set_collision_layer_value(4, true)
    
    collision_mask = 0

func handle_hit(_crit:bool, _value:float = 0.0) -> void:
    #health_component.damage(_value)
    #EventBus.update_ui.emit()
    hited.emit(round(_value), _crit)
    SoundManager.play_sound(load(Master.HIT_SOUNDS))
