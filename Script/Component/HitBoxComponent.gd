@icon("res://addons/EditorIcons/crossed-swords.svg")
class_name HitBoxComponent extends Area2D

signal handled_hit

@export var disable_target:Node2D

var damage:int = 10

func _ready() -> void:
    set_collision_mask_value(2, true)
    area_entered.connect(handle_damage)

func handle_damage(body:Node) -> void:
    # 主要是匹配玩家
    if disable_target:
        if body.owner == disable_target:
            return
    
    if body is HurtBoxComponent:
        body.handle_hit(damage)
        handled_hit.emit()
