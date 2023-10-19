extends CanvasLayer

@onready var hp_bar:ProgressBar = %HpBar
@onready var xp_bar:ProgressBar = %XpBar

@onready var inventory_btn:Button = %InventoryBtn
@onready var character_btn:Button = %CharacterBtn
@onready var skill_tree_btn:Button = %SkillTreeBtn
@onready var get_skill_btn:Button = %GetSkillBtn

@onready var inventory_ui:Control = $Inventory
@onready var character_panel_ui:Control = $CharacterPanel
@onready var skill_tree_ui:Control = $SkillTree

@onready var skill_bar:HBoxContainer = %SkillBar

enum PAGE {
    HOME,
    CHARACTER_PANEL,
    INVENTORY,
    SKILL_TREE
}

var player_data:CharacterData

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)
    EventBus.new_drop_item.connect(new_drop_item)
    EventBus.player_ability_change.connect(build_ability_ui)
    EventBus.show_damage_number.connect(func(_pos:Vector2, _text:String):
        var _damage_label:Label = Builder.build_a_damage_label()
        _damage_label.global_position = _pos
        _damage_label.text = _text
        add_child(_damage_label)
        )
    
    inventory_btn.pressed.connect(change_page.bind(PAGE.INVENTORY))
    character_btn.pressed.connect(change_page.bind(PAGE.CHARACTER_PANEL))
    skill_tree_btn.pressed.connect(change_page.bind(PAGE.SKILL_TREE))
    get_skill_btn.pressed.connect(func():
        EventBus.player_get_a_ability.emit(Master.get_random_ability())
        )
    
    build_ability_ui()
    
    player_data = Master.player.data
    
    set_skills_ui()
    update_ui()
    change_page(PAGE.HOME)

func change_page(_page:PAGE) -> void:
    match _page:
        PAGE.HOME:
            inventory_ui.hide()
            character_panel_ui.hide()
            skill_tree_ui.hide()
        PAGE.CHARACTER_PANEL:
            skill_tree_ui.hide()
            inventory_ui.hide()
            character_panel_ui.show()
        PAGE.INVENTORY:
            skill_tree_ui.hide()
            inventory_ui.show()
            character_panel_ui.hide()
        PAGE.SKILL_TREE:
            skill_tree_ui.show()
            inventory_ui.hide()
            character_panel_ui.hide()

# 技能条 UI
# FIXME: 添加多个技能，第二个技能无效
func set_skills_ui() -> void:
    for _i in Master.player.get_ability_list().size():
        var _ability:FlowerAbility = Master.player.get_ability_list()[_i - 1]
        skill_bar.get_child(_i).set_ability(_ability)

func build_ability_ui() -> void:
    for i in skill_bar.get_children():
        i.queue_free()
    
    for i in Master.player.get_ability_list().size():
        skill_bar.add_child(Builder.builder_a_skill_btn())
    
    set_skills_ui()

func update_ui() -> void:
    hp_bar.value = (float(player_data.hp) / float(player_data.max_hp)) * 100.0
    xp_bar.value = (float(player_data.now_xp) / float(player_data.next_level_xp)) * 100.0

func new_drop_item(_item:InventoryItem, _pos:Vector2) -> void:
    var _new_sprite:Node2D = Builder.build_a_drop_item()
    _new_sprite.set_texture(load(_item.texture_path))
    _new_sprite.global_position = _pos
    
    add_child(_new_sprite)
    
    if _pos.x >= 1080:
        _pos.x = 600
    if _pos.y >= 1920:
        _pos.y = 800
    
    EventBus.add_item.emit(_item)
    EventBus.update_inventory.emit()
