extends Node2D

signal criticaled

@export var buff_manager:FlowerBuffManager:
    set(v):
        buff_manager = v
        $Sprite2D/HitBoxComponent.buff_manager = buff_manager


signal animation_ok

func _ready() -> void:
    $Sprite2D.rotation = 0.0
    $Sprite2D/HitBoxComponent.criticaled.connect(func():
        print("暴击，发送信号一次")
        criticaled.emit())

func set_dis_target(_target:Node2D) -> void:
    $Sprite2D/HitBoxComponent.disable_target = _target

func set_dis_target_group(_target:String) -> void:
    $Sprite2D/HitBoxComponent.disable_target_group = _target

func change_weapon_sprite(_texture:Texture2D) -> void:
    $Sprite2D.texture = _texture

func run(atk_speed:float) -> void:
    var tween:Tween = create_tween().bind_node(self)
    
    tween.tween_property($Sprite2D, "rotation_degrees", 50.0, atk_speed)
    tween.tween_property($Sprite2D, "rotation_degrees", 110.0, atk_speed)
    
    await tween.finished
    tween.kill()
    
    animation_ok.emit()
