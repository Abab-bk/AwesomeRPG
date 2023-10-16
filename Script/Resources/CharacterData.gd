class_name CharacterData
extends FlowerData

signal hp_is_zero

@export var level:int = 1
@export var now_xp:int = 0
@export var next_level_xp:int = 0
# ======= 战斗属性
@export var hp:int:
    set(v):
        hp = v
        if hp <= 0:
            hp_is_zero.emit()
@export var max_hp:int
@export var magic:int
@export var strength:int
@export var wisdom:int
@export var agility:int
@export var luck:float
@export var speed:int
@export var damage:float
@export var defense:float
@export var fire_damage:float
@export var frost_damage:float
@export var light_damage:float
@export var toxic_damage:float
@export var fire_resistance:float
@export var frost_resistance:float
@export var light_resistance:float
@export var toxic_resistance:float
@export var physical_resistance:float
@export var critical_rate:float
@export var critical_damage:float
@export var vulnerability_rate:float
@export var vulnerability_damage:float
@export var evasion:float
@export var health_regeneration:float
@export var healing_effciency:float

@export var vision:int
@export var atk_speed:float
@export var atk_cd:float
@export var atk_range:float
@export var quipments:Dictionary = {}

func update_next_xp() -> void:
    if level % 15 == 0:
        @warning_ignore("integer_division")
        next_level_xp = level / 15 * 1000
    elif level % 10 == 0:  
        @warning_ignore("integer_division")
        next_level_xp = level / 10 * 100
    elif level % 5 == 0:
        @warning_ignore("integer_division")
        next_level_xp = level / 5 * 10
    else:
        next_level_xp += 100
