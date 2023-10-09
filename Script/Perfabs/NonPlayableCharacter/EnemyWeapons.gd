extends Marker2D

signal animation_ok

@onready var weapons_1:Node2D = $WeaponComponent

func play(atk_speed:float) -> void:
    weapons_1.run(atk_speed)
    await weapons_1.animation_ok
    animation_ok.emit()
