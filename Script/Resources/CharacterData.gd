class_name CharacterData
extends FlowerData

signal hp_is_zero

@export var level:int = 1
@export var now_xp:float = 0
@export var next_level_xp:float = 0
# ======= 战斗属性
@export var hp:float:
    set(v):
        hp = v
        if hp <= 0:
            hp = 0
            hp_is_zero.emit()

@export var max_hp:float
@export var magic:float
@export var max_magic:float
@export var strength:int:
    set(v):
        defense += v - strength
        strength = v
@export var wisdom:int:
    set(v):
        max_magic += v - wisdom
        wisdom = v
@export var agility:int:
    set(v):
        evasion += ((v - agility) * 0.025)
        agility = v
@export var luck:float
@export var speed:float
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

func load_save(_save:Dictionary) -> void:
    for i in _save:
        self[str(i)] = _save[i]

func set_property_from_level() -> void:
    max_hp += level * 6
    max_magic += level * 3
    evasion += level
    
    fire_damage = level * 2
    frost_damage = level * 2
    toxic_damage = level * 2
    light_damage = level * 2
    fire_resistance = level * 2
    frost_resistance = level * 2
    toxic_resistance = level * 2
    speed = level * (1.0 + randf_range(0.0, 2.0))
    
    strength = level
    wisdom = level
    agility = level

func level_up() -> void:
    level += 1
    
    max_hp += 6
    max_magic += 3
    evasion += 1
    
    strength += 1
    wisdom += 1
    agility += 1

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
        next_level_xp += 100.0
