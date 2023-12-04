class_name OtherEnemy extends Node2D

signal range_attacked

@export var hitbox_component:HitBoxComponent
@export var animation_player:AnimationPlayer
@export var range_attack:bool = false
@export var bullet_spawn_point:Marker2D = null


func emit_range_attack_signal() -> void:
    range_attacked.emit()
