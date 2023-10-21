extends Node

const enemy := preload("res://Scene/Perfabs/NonPlayCharacter/Enemy.tscn")
const fireball:String = "res://Scene/Perfabs/Bullets/FireBall.tscn"
const inventory_item := preload("res://Scene/UI/InventoryItem.tscn")
const skill_btn:String = "res://Scene/UI/SkillItem.tscn"
const affix_label:String = "res://Scene/UI/AffixLabel.tscn"
const skill_tree_btn:String = "res://Scene/UI/SkillTreeItem.tscn"
const drop_item:String = "res://Scene/Perfabs/Others/DropItem.tscn"
const damage_label:String = "res://Scene/UI/DamageLable.tscn"
const popup:String = "res://Scene/UI/Popup.tscn"
const select_skills_panel:String = "res://Scene/UI/SelectSkillsPanel.tscn"
const info_skill_btn:String = "res://Scene/UI/SkillBtn.tscn"

func build_a_info_skill_btn() -> TextureRect:
    var _n:TextureRect = load(info_skill_btn).instantiate()
    return _n

func build_a_select_sills_panel() -> Panel:
    var _n:Panel = load(select_skills_panel).instantiate()
    return _n

func build_a_popup() -> NinePatchRect:
    var _n:NinePatchRect = load(popup).instantiate()
    return _n

func build_a_damage_label() -> Label:
    var _n:Label = load(damage_label).instantiate()
    return _n

func build_a_drop_item() -> Node2D:
    var _n:Node2D = load(drop_item).instantiate()
    return _n

func build_a_affix_label() -> HBoxContainer:
    var _n:HBoxContainer = load(affix_label).instantiate()
    return _n

func build_a_fireball() -> CharacterBody2D:
    var _n:CharacterBody2D = load(fireball).instantiate()
    return _n

func build_a_skill_btn() -> Panel:
    var _n = load(skill_btn).instantiate()
    return _n

func build_a_enemy() -> Enemy:
    var _n = enemy.instantiate()
    return _n

func build_a_inventory_item() -> Panel:
    var _n = inventory_item.instantiate()
    return _n

func build_a_skill_tree_item() -> NinePatchRect:
    var _n = load(skill_tree_btn).instantiate()
    return _n
