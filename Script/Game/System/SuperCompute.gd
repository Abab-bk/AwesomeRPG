class_name SuperComputer extends Node

static func handle_damage_dic(actor:CharacterData, target:CharacterData) -> Dictionary:
    var _damage_dic:Dictionary = get_damage_dic(actor, target)
    var _damage:float = _damage_dic.damage - get_defens(actor)
    target.hp -= _damage
    
    return {
        "damage": _damage,
        "crit": _damage_dic.crit
    }


static func handle_damage(actor:CharacterData, target:CharacterData) -> float:
    var _damage:float = get_damage(actor) - get_defens(actor)
    target.hp -= _damage
    
    return _damage


static func handle_fire_damage(actor:CharacterData, target:CharacterData) -> void:
    target.hp -= actor.fire_damage - target.fire_resistance


static func handle_frost_damage(actor:CharacterData, target:CharacterData) -> void:
    target.hp -= actor.frost_damage - target.frost_resistance


static func get_defens(_who:CharacterData) -> float:
    return 0.0


static func get_damage(who:CharacterData) -> float:
    var root_stats:float = who.wisdom + who.agility + who.strength
    var base_damage:float = who.damage
    var critical_damage:float = 0.0
    
    var element_damage:float = (1.0 + who.fire_damage) * (1.0 + who.frost_damage) * (1.0 + who.toxic_damage) * (1.0 + who.light_damage)
    
    var is_critical:bool = false
        
    if randf_range(0.0, 1.0) <= who.critical_rate:
        is_critical = true
        
    if is_critical:
        critical_damage = 1.0 + who.critical_rate * who.critical_damage
        #criticaled.emit()
        #EventBus.player_criticaled.emit()
    
    # element_damage 可能有问题？ 请查看公式
    var sheet_damage:float = root_stats * element_damage * base_damage * \
    (critical_damage)
    
    var real_damage:float = sheet_damage
    
    return real_damage


static func get_damage_dic(who:CharacterData, target:CharacterData) -> Dictionary:
    if not who:
        return {
            "damage": 0,
            "crit": false
        }
    
    var root_stats:float = max(1.0, (who.wisdom + who.agility + who.strength) * 0.5)
    var base_damage:float = who.damage
    var critical_damage:float = 1.0
    
    var element_damage:float = (1.0 + who.fire_damage) - get_fire_resistance_in_2_actor(who, target) \
    * (1.0 + who.frost_damage) - get_frost_resistance_in_2_actor(who, target) \
    * (1.0 + who.toxic_damage) - get_toxic_resistance_in_2_actor(who, target) \
    * (1.0 + who.light_damage) - get_light_resistance_in_2_actor(who, target)
        
    var is_critical:bool = false
    
    randomize()
    if randf_range(0.0, 1.0) <= who.critical_rate:
        is_critical = true
        
    if is_critical:
        critical_damage = 1.0 + who.critical_rate * who.critical_damage
    
    # element_damage 可能有问题？ 请查看公式
    var sheet_damage:float = root_stats * element_damage * base_damage * critical_damage
    
    var real_damage:float = sheet_damage
    
    return {
        "damage": real_damage,
        "crit": is_critical
    }


static func get_fire_resistance_in_2_actor(who:CharacterData, target:CharacterData) -> float:
    return min(1.0, floor(who.fire_resistance / (5 * target.level + who.fire_resistance)))


static func get_toxic_resistance_in_2_actor(who:CharacterData, target:CharacterData) -> float:
    return min(1.0, floor(who.toxic_resistance / (5 * target.level + who.toxic_resistance)))


static func get_frost_resistance_in_2_actor(who:CharacterData, target:CharacterData) -> float:
    return min(1.0, floor(who.frost_resistance / (5 * target.level + who.frost_resistance)))


static func get_light_resistance_in_2_actor(who:CharacterData, target:CharacterData) -> float:
    return min(1.0, floor(who.light_resistance / (5 * target.level + who.light_resistance)))


static func get_physical_resistance_in_2_actor(who:CharacterData, target:CharacterData) -> float:
    return min(1.0, floor(who.physical_resistance / (5 * target.level + who.physical_resistance)))
