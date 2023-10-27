extends Node2D

@export var buff_manager:FlowerBuffManager:
    set(v):
        buff_manager = v
        $Sprite2D/HitBoxComponent.buff_manager = buff_manager


signal animation_ok

func _ready() -> void:
    $Sprite2D.rotation = 0.0

func set_dis_target(_target:Node2D) -> void:
    $Sprite2D/HitBoxComponent.disable_target = _target

func run(atk_speed:float) -> void:
    var tween:Tween = create_tween().bind_node(self)
    
    tween.tween_property($Sprite2D, "rotation_degrees", 50.0, atk_speed)
    tween.tween_property($Sprite2D, "rotation_degrees", 110.0, atk_speed)
    
    await tween.finished
    tween.kill()
    
    animation_ok.emit()
