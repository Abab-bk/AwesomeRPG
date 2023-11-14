class_name RangedWeaponComponent extends Node2D

@export var bullet:PackedScene
@export var buff_manager:FlowerBuffManager

var target_position:Vector2 = Vector2(0, 0)

func attack() -> void:
    var _new = bullet.instantiate() as BulletComponent
    _new.target_pos = target_position
    _new.global_position = global_position
    _new.buff_manager = buff_manager
    #SoundManager.play_sound(load(Master.CLICK_SOUNDS))
    Master.world.call_deferred("add_child", _new)

func _physics_process(_delta:float) -> void:
    look_at(target_position)
