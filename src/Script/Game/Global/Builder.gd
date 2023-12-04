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
const trail:String = "res://Scene/Perfabs/Others/Trail.tscn"
const animation_vfx:String = "res://Scene/Perfabs/Vfx/AnimationVFX.tscn"


func build_a_reward_item_ui(_reward:Reward) -> Panel:
    var _n:Panel = load("res://Scene/UI/RewardItemUi.tscn").instantiate()
    return _n


func build_a_base_bullet(_damage_data:CharacterData, _is_player_hitbox:bool) -> BaseBullet:
    var _n:BaseBullet = load("res://Scene/Perfabs/Bullets/BaseBullet.tscn").instantiate()
    
    _n.damage_data = _damage_data
    _n.is_player_bullet = _is_player_hitbox
    
    return _n


func build_a_sprite_vfx() -> AnimatedSprite2D:
    var _n:AnimatedSprite2D = load(animation_vfx).instantiate()
    return _n


func build_a_recycle_panel() -> ColorRect:
    var _n:ColorRect = load("res://Scene/UI/RecyclePanel.tscn").instantiate()
    return _n


func build_a_trail() -> Sprite2D:
    var _n:Sprite2D = load(trail).instantiate()
    return _n

func build_a_info_skill_btn() -> TextureRect:
    var _n:TextureRect = load(info_skill_btn).instantiate()
    return _n

func build_a_select_sills_panel() -> Panel:
    var _n:Panel = load(select_skills_panel).instantiate()
    return _n

func build_a_popup() -> Panel:
    var _n:Panel = load(popup).instantiate()
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

func build_a_friend() -> Friend:
    var _n = load("res://Scene/Perfabs/PlayabelCharacter/BaseFriend.tscn").instantiate()
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


func get_a_simple_buff(_target_property:String, _value:float, _type:FlowerConst.COMPUTE_TYPE) -> FlowerBaseBuff:
    var _buff:FlowerBaseBuff = FlowerBaseBuff.new()
    _buff.name = ""
    _buff.repeat = false
    _buff.infinite = true
    _buff.prepare_time = 0
    _buff.active_time = 0
    _buff.cooldown_time = 0
    
    var _compute_data:FlowerComputeData = FlowerComputeData.new()
    _compute_data.id = "temp"
    _compute_data.type = _type
    _compute_data.value = _value
    _compute_data.target_property = _target_property    
    
    _buff.compute_values.append(_compute_data)
    
    return _buff
