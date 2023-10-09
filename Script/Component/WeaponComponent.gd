extends Node2D

@export var buff_manager:FlowerBuffManager

var tween:Tween

signal animation_ok

func _ready() -> void:
    $Sprite2D.rotation = 110.0
    $Sprite2D/HitBoxComponent.damage = buff_manager.compute_data.damage

func run(speed:float) -> void:
    if tween:
        tween.kill()
    
    tween = create_tween().bind_node(self)
    tween.tween_property($Sprite2D, "rotation_degrees", 50.0, speed)
    tween.tween_property($Sprite2D, "rotation_degrees", 110.0, speed)
    await tween.finished
    tween.kill()
    
    animation_ok.emit()
