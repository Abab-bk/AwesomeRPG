class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var weapons:Marker2D = %Weapons
@onready var atk_cd_timer:Timer = $AtkCDTimer

var data:CharacterData
var can_attack:bool = false

func _ready() -> void:
    data = buff_manager.compute_data
    
    atk_cd_timer.wait_time = data.atk_cd
    atk_cd_timer.autostart = false
    atk_cd_timer.one_shot = true

func patrol() -> void:
    velocity = Vector2(randi_range(-100, 200), randi_range(-100, 200)) * data.speed
    move_and_slide()

func attack() -> void:
    print("AA")
    can_attack = true
    weapons.play(data.atk_speed)
    await weapons.animation_ok
    EventBus.player_hited.emit(data.damage)
    EventBus.update_ui.emit()
    
    atk_cd_timer.start()
    await atk_cd_timer.timeout
    
    can_attack = false

func get_distance_from_player() -> float:
    var _player:CharacterBody2D = Master.player
    var distance:float = global_position.distance_to(_player.global_position)
    return distance

func get_attack_range() -> float:
    return data.atk_range
