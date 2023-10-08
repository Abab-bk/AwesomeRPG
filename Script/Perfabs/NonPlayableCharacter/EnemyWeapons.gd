extends Marker2D

signal animation_ok

@onready var weapons_1:Sprite2D = $Weapons1

func play(atk_speed:float) -> void:
    weapons_1.rotation = 115.0
    
    var tween:Tween = get_tree().create_tween()
    tween.tween_property(weapons_1, "rotation", 66.0, atk_speed)
    tween.tween_property(weapons_1, "rotation", 115.0, atk_speed)
    await tween.finished
    
    animation_ok.emit()
