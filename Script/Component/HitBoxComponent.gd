@icon("res://addons/EditorIcons/crossed-swords.svg")
class_name HitBoxComponent extends Area2D

var damage:int = 10

func _ready() -> void:
    set_collision_mask_value(2, true)
    area_entered.connect(handle_damage)

func handle_damage(body:Node) -> void:
    if body is HurtBoxComponent:
        body.handle_hit(damage)
