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
@export var fire_damage:float
@export var frost_damage:float
@export var vision:int
@export var atk_speed:float
@export var atk_cd:float
@export var atk_range:float
@export var quipments:Dictionary = {}
