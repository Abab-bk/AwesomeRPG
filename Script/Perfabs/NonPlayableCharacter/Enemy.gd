class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var weapons:Marker2D = %Weapons
@onready var atk_cd_timer:Timer = $AtkCDTimer
@onready var visiable_component:VisiableComponent = $VisiableComponent

var data:CharacterData
var can_attack:bool = false

func _ready() -> void:
    data = buff_manager.compute_data
    
    $VisiableComponent/CollisionShape2D.shape.set_radius(data.atk_range)
    
    atk_cd_timer.wait_time = data.atk_cd
    atk_cd_timer.autostart = false
    atk_cd_timer.one_shot = true

func _physics_process(delta: float) -> void:
    move_and_slide()

func attack() -> void:
    can_attack = true
    
    weapons.play(data.atk_speed)
    await weapons.animation_ok
    
    EventBus.update_ui.emit()
    
    atk_cd_timer.start()
    await atk_cd_timer.timeout
    
    can_attack = false

func body_is_in_visiable() -> bool:
    return visiable_component.target_is_in_range(Master.player)

func get_speed() -> int:
    return data.speed

func get_attack_range() -> float:
    return data.atk_range
