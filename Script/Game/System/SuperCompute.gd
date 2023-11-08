class_name SuperComputer extends Node

enum DAMAGE_TYPE {
    PHYSICAL,
    ELEMENT
}

static func handle_damage(actor:CharacterData, target:CharacterData) -> float:
    var _damage:float = get_damage(actor) - get_defens(actor)
    target.hp -= _damage
    
    return _damage

static func handle_fire_damage(actor:CharacterData, target:CharacterData) -> void:
    target.hp -= actor.fire_damage - target.fire_resistance

static func handle_frost_damage(actor:CharacterData, target:CharacterData) -> void:
    target.hp -= actor.frost_damage - target.frost_resistance

static func get_defens(who:CharacterData) -> float:
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
    
    var sheet_damage:float = root_stats * base_damage * \
    (critical_damage)
    
    var real_damage:float = sheet_damage
    
    return real_damage

