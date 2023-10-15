extends Node

const enemy := preload("res://Scene/Perfabs/NonPlayCharacter/Enemy.tscn")
const fireball:String = "res://Scene/Perfabs/Bullets/FireBall.tscn"
const inventory_item := preload("res://Scene/UI/InventoryItem.tscn")
const skill_btn:String = "res://Scene/UI/SkillItem.tscn"

func build_a_fireball() -> CharacterBody2D:
    var _n:CharacterBody2D = load(fireball).instantiate()
    return _n

func builder_a_skill_btn() -> SkillBtn:
    var _n:SkillBtn = load(skill_btn).instantiate()
    return _n

func builder_a_enemy() -> Enemy:
    var _n = enemy.instantiate()
    return _n

func builder_a_inventory_item() -> Panel:
    var _n = inventory_item.instantiate()
    return _n
