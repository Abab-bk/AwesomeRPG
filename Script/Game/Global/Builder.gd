extends Node

const enemy := preload("res://Scene/Perfabs/NonPlayCharacter/Enemy.tscn")
const fireball:String = "res://Scene/Perfabs/Bullets/FireBall.tscn"
const inventory_item := preload("res://Scene/UI/InventoryItem.tscn")
const skill_btn:String = "res://Scene/UI/SkillItem.tscn"
const affix_label:String = "res://Scene/UI/AffixLabel.tscn"
const skill_tree_btn:String = "res://Scene/UI/SkillTreeItem.tscn"

func build_a_affix_label() -> HBoxContainer:
    var _n:HBoxContainer = load(affix_label).instantiate()
    return _n

func build_a_fireball() -> CharacterBody2D:
    var _n:CharacterBody2D = load(fireball).instantiate()
    return _n

func builder_a_skill_btn() -> Panel:
    var _n = load(skill_btn).instantiate()
    return _n

func builder_a_enemy() -> Enemy:
    var _n = enemy.instantiate()
    return _n

func builder_a_inventory_item() -> Panel:
    var _n = inventory_item.instantiate()
    return _n

func builder_a_skill_tree_item() -> NinePatchRect:
    var _n = load(skill_tree_btn).instantiate()
    return _n
