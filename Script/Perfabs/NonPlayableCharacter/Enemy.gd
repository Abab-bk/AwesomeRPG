class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager

var data:CharacterData

func _ready() -> void:
    data = buff_manager.compute_data

func patrol() -> void:
    velocity = Vector2(randi_range(-100, 200), randi_range(-100, 200)) * data.speed
    move_and_slide()

func attack() -> void:
    EventBus.player_hited.emit(data.damage)
    EventBus.update_ui.emit()

func get_distance_from_player() -> float:
    var _player:CharacterBody2D = Master.player
    var distance:float = global_position.distance_to(_player.global_position)
    return distance

func get_attack_range() -> float:
    return data.atk_range
