@icon("res://addons/EditorIcons/crossed-swords.svg")
class_name HitBoxComponent extends Area2D

signal handled_hit

var buff_manager:FlowerBuffManager:
    set(_v):
        buff_manager = _v
        if buff_manager:
            data = buff_manager.compute_data

@export var disable_target:Node2D

var data:CharacterData

func _ready() -> void:
    set_collision_mask_value(2, true)
    area_entered.connect(handle_damage)

func handle_damage(body:Node) -> void:
    # 主要是匹配玩家
    if disable_target:
        if body.owner == disable_target:
            return
    
    if body is HurtBoxComponent:
        var root_stats:float = 1.0
        var base_damage:float = data.damage
        var sheet_damage:float = root_stats * base_damage * \
        (1.0 + data.critical_rate * data.critical_damage)
        
        var real_damage:float = sheet_damage
        
        body.handle_hit(real_damage)
        handled_hit.emit()
