class_name Weapons extends Node2D

signal animation_ok

@export var atk_cd_timer:Timer

@onready var weapons_1:Node2D = $WeaponComponent

var attacking:bool = false

func attack(atk_speed:float) -> void:
    attacking = true
    
    weapons_1.run(atk_speed)
    await weapons_1.animation_ok
    
    atk_cd_timer.start()
    await atk_cd_timer.timeout
    
    attacking = false
    
    EventBus.update_ui.emit()
