extends CanvasLayer

signal changed_to_other
signal backed_to_home

@onready var mp_bar:TextureProgressBar = %MpBar
@onready var hp_bar:TextureProgressBar = %HpBar
@onready var xp_bar:ProgressBar = %XpBar

@onready var coins_label:Label = %CoinsLabel
@onready var level_label:Label = %LevelLabel
@onready var level_level_label:Label = %LevelLevelLabel

@onready var inventory_btn:TextureButton = %InventoryBtn
@onready var character_btn:TextureButton = %CharacterBtn
@onready var skill_tree_btn:TextureButton = %SkillTreeBtn
@onready var skills_panel_btn:TextureButton = %SillsPanelBtn
@onready var setting_btn:TextureButton = %SettingBtn
@onready var store_btn:TextureButton = %StoreBtn

@onready var get_skill_btn:Button = %GetSkillBtn

@onready var inventory_ui:Control = $Inventory
@onready var character_panel_ui:Control = $CharacterPanel
@onready var skill_tree_ui:Control = $SkillTree
@onready var setting_ui:Control = $SettingUI
@onready var skills_panel_ui:Control = $SkillsPanel
@onready var quest_panel:Control = %QuestPanel
@onready var store_ui:Control = $StoreUI

@onready var skill_bar:HBoxContainer = %SkillBar
@onready var color_rect:ColorRect = $ColorRect

enum PAGE {
    HOME,
    CHARACTER_PANEL,
    INVENTORY,
    SKILL_TREE,
    SKILLS_PANEL,
    SETTING,
    STORE
}

var player_data:CharacterData

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)
    EventBus.show_popup.connect(show_popup)
    EventBus.new_drop_item.connect(new_drop_item)
    EventBus.player_ability_change.connect(build_ability_ui)
    EventBus.player_dead.connect(update_ui)
    EventBus.show_damage_number.connect(func(_pos:Vector2, _text:String):
        var _damage_label:Label = Builder.build_a_damage_label()
        _damage_label.position = _pos
        _damage_label.text = _text
        add_child(_damage_label)
        )
    EventBus.coins_changed.connect(func():
        coins_label.text = str(Master.coins))
    EventBus.show_select_skills_panel.connect(func(_target:Panel):
        var _panel:Panel = Builder.build_a_select_sills_panel()
        _panel.target_skill_panel = _target
        add_child(_panel)
        )
    EventBus.show_color.connect(show_color_rect)
    EventBus.hide_color.connect(hide_color_rect)
    EventBus.new_tips.connect(new_tip)
    
    EventBus.player_level_up.connect(show_animation.bind("LevelUp"))
    
    backed_to_home.connect(func():quest_panel.show())
    changed_to_other.connect(func():quest_panel.hide())
    
    inventory_btn.pressed.connect(change_page.bind(PAGE.INVENTORY))
    character_btn.pressed.connect(change_page.bind(PAGE.CHARACTER_PANEL))
    setting_btn.pressed.connect(change_page.bind(PAGE.SETTING))
    skill_tree_btn.pressed.connect(change_page.bind(PAGE.SKILL_TREE))
    skills_panel_btn.pressed.connect(change_page.bind(PAGE.SKILLS_PANEL))
    store_btn.pressed.connect(change_page.bind(PAGE.STORE))
    # 添加技能
    get_skill_btn.pressed.connect(func():
        var _ability:FlowerAbility = Master.get_random_ability()
#        EventBus.player_get_a_ability.emit(_ability)
        EventBus.unlocked_ability.emit(_ability.id)
        EventBus.show_popup.emit("解锁技能", "解锁技能：%s" % _ability.name)
        )
    
    player_data = Master.player.output_data
    
    build_ability_ui()
    
    hide_color_rect()
    update_ui()
    change_page(PAGE.HOME)

func change_page(_page:PAGE) -> void:
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    match _page:
        PAGE.HOME:
            inventory_ui.hide()
            character_panel_ui.hide()
            skill_tree_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            store_ui.hide()
            backed_to_home.emit()
        PAGE.CHARACTER_PANEL:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.show()
            store_ui.hide()
            changed_to_other.emit()
        PAGE.INVENTORY:
            skill_tree_ui.hide()
            inventory_ui.show()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.hide()
            changed_to_other.emit()
        PAGE.SKILL_TREE:
            skill_tree_ui.show()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.hide()
            changed_to_other.emit()
        PAGE.SETTING:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.show()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.hide()
            changed_to_other.emit()
        PAGE.SKILLS_PANEL:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.show()
            character_panel_ui.hide()
            store_ui.hide()
            changed_to_other.emit()
        PAGE.STORE:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.show()
            changed_to_other.emit()

# 技能条 UI
func build_ability_ui() -> void:
    for i in skill_bar.get_children():
        if i.ability:
            i.ability.un_active()
        
        i.queue_free()
    
    for i in Master.player.get_ability_list().size():
        var _ability:FlowerAbility = Master.player.get_ability_list()[i - 1]
        
        if _ability.is_sub_ability:
            continue
        
        if _ability.id == 4005:
            _ability.active()
            continue
        
        var _skill_btn:Panel = Builder.build_a_skill_btn()
        skill_bar.add_child(_skill_btn)
        _skill_btn.set_ability(_ability)

func update_ui() -> void:
    level_label.text = "Lv.%s" % str(player_data.level)
    level_level_label.text = "第 %s 关" % str(Master.current_level)
    mp_bar.value = (float(player_data.magic) / float(player_data.max_magic)) * 100.0
    hp_bar.value = (float(player_data.hp) / float(player_data.max_hp)) * 100.0
    xp_bar.value = (float(player_data.now_xp) / float(player_data.next_level_xp)) * 100.0

func new_drop_item(_item:InventoryItem, _pos:Vector2) -> void:
    var _new_sprite:Node2D = Builder.build_a_drop_item()
    _new_sprite.set_texture(load(_item.texture_path))
    _new_sprite.position = _pos
    
    add_child(_new_sprite)
    
    if _pos.x >= 1080:
        _pos.x = 600
    if _pos.y >= 1920:
        _pos.y = 800
    
    EventBus.add_item.emit(_item)
    EventBus.update_inventory.emit()

func show_color_rect() -> void:
    color_rect.show()

func hide_color_rect() -> void:
    color_rect.hide()

func show_animation(_key:String) -> void:
    if _key == "LevelUp":
        SoundManager.play_sound(load(Master.HAPPY_SOUNDS))
        var _img:Control = load("res://Scene/UI/LevelUpAnimation.tscn").instantiate()
        add_child(_img)

func new_tip(_text:String) -> void:
    var _n = load("res://Scene/UI/Tips.tscn").instantiate()
    _n.text = _text
    add_child(_n)

func show_popup(_title:String, _desc:String, _show_cancel_btn:bool = false, _yes_event:Callable = func():,
 _cancel_event:Callable = func():) -> void:
    hide_color_rect()
    SoundManager.play_ui_sound(load(Master.POPUP_SOUNDS))
    var _popup:NinePatchRect = Builder.build_a_popup()
    
    _popup.closed.connect(func():hide_color_rect())
    
    _popup.title = _title
    _popup.desc = _desc
    _popup.show_cancel_btn = _show_cancel_btn
    _popup.yes_event = _yes_event
    _popup.cancel_event = _cancel_event
    
    add_child(_popup)
