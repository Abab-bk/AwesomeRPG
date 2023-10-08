class_name CharacterData
extends FlowerData

signal hp_is_zero

@export var hp:int:
    set(v):
        hp = v
        if hp <= 0:
            hp_is_zero.emit()
@export var max_hp:int
@export var mp:int
@export var speed:int
@export var damage:int
@export var atk_speed:int
@export var atk_range:float
