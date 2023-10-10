class_name VisionComponent extends Area2D

@export var buff_manager:FlowerBuffManager

func _ready() -> void:
    var data:FlowerData = buff_manager.compute_data
    $CollisionShape2D.shape.set_radius(data.vision)

func target_is_in_range(target:Node) -> bool:
    if overlaps_body(target):
        return true
    return false
