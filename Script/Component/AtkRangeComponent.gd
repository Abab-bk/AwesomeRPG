class_name AtkRangeComponent extends Area2D

signal target_enter_range
signal target_exited_range

@export var buff_manager:FlowerBuffManager

var target:Node2D = null

func _ready() -> void:
    var data:FlowerData = buff_manager.compute_data
    $CollisionShape2D.shape.set_radius(data.atk_range)
    body_entered.connect(func(_body:Node2D): if _body == target: target_enter_range.emit())
    body_exited.connect(func(_body:Node2D): if _body ==  target: target_exited_range.emit())

func target_is_in_range(_target:Node) -> bool:
    if overlaps_body(_target):
        return true
    return false
