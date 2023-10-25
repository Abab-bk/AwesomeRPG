class_name VisionComponent extends Area2D

signal target_enter_range

@export var buff_manager:FlowerBuffManager

var target:Node2D = null

func _ready() -> void:
    var data:FlowerData = buff_manager.compute_data
    $CollisionShape2D.shape.set_radius(data.vision)
    body_entered.connect(func(_body:Node2D): if _body == target: target_enter_range.emit())

func target_is_in_range(_target:Node) -> bool:
    if overlaps_body(_target):
        return true
    return false
