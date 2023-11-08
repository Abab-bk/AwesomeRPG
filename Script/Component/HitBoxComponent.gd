@icon("res://addons/EditorIcons/crossed-swords.svg")
class_name HitBoxComponent extends Area2D

signal handled_hit(value:float, actor)
signal criticaled

@export var buff_manager:FlowerBuffManager:
    set(_v):
        buff_manager = _v
        if buff_manager:
            data = buff_manager.output_data
            
@export var is_player_hitbox:bool
@export var disable_target:Node2D

@export var disable_target_group:String = ""

var data:CharacterData
var damage_data:CharacterData
var damage:float

func _ready() -> void:
    if buff_manager:
        buff_manager.compute_ok.connect(func():
            data = buff_manager.output_data
            damage_data = data
        )
    
    collision_layer = 0
    collision_mask = 0
    
    if is_player_hitbox:
        set_collision_layer_value(7, true)
        set_collision_mask_value(4, true)
        handled_hit.connect(func(value:float, enemy:Enemy):
            if enemy is Enemy:
                enemy.show_damage_label(int(value))
            )
    else:
        set_collision_layer_value(5, true)
        set_collision_mask_value(6, true)
    
    area_entered.connect(handle_damage)

func get_enemys() -> Array:
    return get_overlapping_bodies()

func handle_damage(body:Node) -> void:
    # 主要是匹配玩家
    if disable_target:
        if body.owner == disable_target:
            return
    
    if body.owner.is_in_group(disable_target_group):
        return
    
    if body is HurtBoxComponent:
        handled_hit.emit(SuperComputer.handle_damage(damage_data, body.owner.output_data), body.owner)
