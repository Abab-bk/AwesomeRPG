class_name CharacterData
extends FlowerData

signal hp_is_zero

@export var level:int = 1
@export var now_xp:float = 0
@export var next_level_xp:float = 20
# ======= 战斗属性
@export var hp:float:
    set(v):
        if v <= 0.0:
            hp = 0.0
            hp_is_zero.emit()
            return
        
        if v > max_hp:
            hp = max_hp
            return
        
        hp = v

@export var max_hp:float
@export var magic:float:
    set(v):
        if v <= 0.0:
            magic = 0.0
        if v > max_magic:
            magic = max_magic
            return
        magic = v

@export var max_magic:float
@export var strength:int
@export var wisdom:int
@export var agility:int
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

@export var weapon_damage:float

@export var vision:int = 360
@export var atk_speed:float = 0.5
@export var atk_cd:float = 0.5:
    set(v):
        if v <= 0.2:
            atk_cd = 0.2
            return
        atk_cd = v

@export var atk_range:float = 125
@export var quipments:Dictionary = {}

@export var name:String = ""

func load_save(_save:Dictionary) -> void:
    for i in _save:
        self[str(i)] = _save[i]


func set_property_from_level() -> void:
    max_hp += level * 6
    max_magic += level * 3
    evasion += level
    
    fire_damage += level * 0.01
    frost_damage += level * 0.01
    toxic_damage += level * 0.01
    light_damage += level * 0.01
    fire_resistance += level * 0.01
    frost_resistance += level * 0.01
    toxic_resistance += level * 0.01
    speed += level * (1.0 + randf_range(0.0, 2.0))
    
    strength += floor(float(level) / 2.0)
    wisdom += floor(float(level) / 2.0)
    agility += floor(float(level) / 2.0)
    
    max_magic += wisdom
    defense += strength
    evasion += agility * 0.025


func set_property_from_const_level(_level:int) -> void:
    max_hp += _level * 6
    max_magic += _level * 3
    evasion += _level
    
    fire_damage += _level * 0.01
    frost_damage += _level * 0.01
    toxic_damage += _level * 0.01
    light_damage += _level * 0.01
    fire_resistance += _level * 0.01
    frost_resistance += _level * 0.01
    toxic_resistance += _level * 0.01
    speed += _level * (1.0 + randf_range(0.0, 2.0))
    
    strength += floor(float(_level) / 2.0)
    wisdom += floor(float(_level) / 2.0)
    agility += floor(float(_level) / 2.0)
    
    max_magic += wisdom
    defense += strength
    evasion += agility * 0.025


func level_up() -> Dictionary:
    now_xp = 0
    level += 1
    
    max_hp += 6
    max_magic += 3
    evasion += 1
    
    strength += 1
    wisdom += 1
    agility += 1

    max_magic += wisdom
    defense += strength
    evasion += agility * 0.025

    return {
        "等级": [level - 1, level],
        "最大血量": [max_hp - 6, max_hp],
        "最大魔力": [max_magic - 3, max_magic],
        "闪避": [evasion - 1, evasion],
        "力量": [strength - 1, strength],
        "智慧": [wisdom - 1, wisdom],
        "敏捷": [agility - 1, agility],
    }


func reset_hp_and_magic() -> void:
    hp = max_hp
    magic = max_magic


func update_next_xp() -> void:
    #next_level_xp = 50 * (pow(level, 3))
    next_level_xp = (15 + (level ** 3)) * (1.07 ** level)
    #if level % 15 == 0:
        #@warning_ignore("integer_division")
        #next_level_xp = level / 15 * 1000
    #elif level % 10 == 0:  
        #@warning_ignore("integer_division")
        #next_level_xp = level / 10 * 100
    #elif level % 5 == 0:
        #@warning_ignore("integer_division")
        #next_level_xp = level / 5 * 10
    #else:
        #next_level_xp += 100.0
