class_name RangedWeaponComponent extends Node2D

@export var bullet:PackedScene
@export var buff_manager:FlowerBuffManager
@export var should_atk:bool = false

var target_position:Vector2 = Vector2(0, 0)

func attack() -> void:
    if not should_atk:
        return
    
    var _new = bullet.instantiate() as BulletComponent
    _new.target_pos = target_position
    _new.global_position = global_position
    _new.buff_manager = buff_manager
    Master.world.call_deferred("add_child", _new)

func _physics_process(_delta:float) -> void:
    look_at(target_position)
