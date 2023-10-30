@icon("res://addons/EditorIcons/crossed-swords.svg")
class_name HitBoxComponent extends Area2D

signal handled_hit
signal criticaled

@export var buff_manager:FlowerBuffManager:
    set(_v):
        buff_manager = _v
        if buff_manager:
            data = buff_manager.output_data

@export var disable_target:Node2D

@export var disable_target_group:String = ""

var data:CharacterData

func _ready() -> void:
    buff_manager.compute_ok.connect(func():
        data = buff_manager.output_data
    )
    
    set_collision_mask_value(4, true)
    set_collision_mask_value(1, false)
    collision_layer = 0
    
    area_entered.connect(handle_damage)

func handle_damage(body:Node) -> void:
    # 主要是匹配玩家
    if disable_target:
        if body.owner == disable_target:
            return
    
    if body.owner.is_in_group(disable_target_group):
        return
    
    if body is HurtBoxComponent:
        
        var root_stats:float = data.wisdom + data.agility + data.strength
        var base_damage:float = data.damage
        var critical_damage:float = 1.0
        
        var is_critical:bool = false
        
        if randf_range(0.0, 1.0) <= data.critical_rate:
           is_critical = true
        
        if is_critical:
            critical_damage = 1.0 + data.critical_rate * data.critical_damage
            criticaled.emit()
#            print("暴击！额外造成伤害：", critical_damage)
        
        var sheet_damage:float = root_stats * base_damage * \
        (critical_damage)
        
        var real_damage:float = sheet_damage
        
        body.handle_hit(real_damage)
        handled_hit.emit()
        print("[Hit] %s => %s" % [self.owner.name, body.owner.name])
