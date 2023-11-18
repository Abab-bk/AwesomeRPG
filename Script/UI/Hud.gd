extends CanvasLayer

signal changed_to_other
signal backed_to_home

@onready var mp_bar:TextureProgressBar = %MpBar
@onready var hp_bar:TextureProgressBar = %HpBar

@onready var xp_bar:ProgressBar = %XpBar

@onready var coins_label:Label = %CoinsLabel
@onready var level_label:Label = %LevelLabel
@onready var level_level_label:Label = %LevelLevelLabel
@onready var player_name_label:Label = %PlayerNameLabel

@onready var inventory_btn:TextureButton = %InventoryBtn
@onready var character_btn:Button = %CharacterBtn
@onready var skill_tree_btn:TextureButton = %SkillTreeBtn
@onready var skills_panel_btn:TextureButton = %SillsPanelBtn
@onready var setting_btn:TextureButton = %SettingBtn
@onready var store_btn:TextureButton = %StoreBtn
@onready var dungeon_btn:TextureButton = %DungeonBtn
@onready var forge_btn:TextureButton = %ForgeBtn

@onready var get_skill_btn:Button = %GetSkillBtn

@onready var inventory_ui:Control = $Pages/Inventory
@onready var character_panel_ui:Control = $Pages/CharacterPanel
@onready var skill_tree_ui:Control = $Pages/SkillTree
@onready var setting_ui:Control = $Pages/SettingUI
@onready var skills_panel_ui:Control = $Pages/SkillsPanel
@onready var quest_panel:Control = %QuestPanel
@onready var store_ui:Control = $Pages/StoreUI
@onready var dungeon_ui:Control = $DungeonPanel
@onready var forge_room:Control = $Pages/ForgeRoom

@onready var skill_bar:HBoxContainer = %SkillBar
@onready var color_rect:ColorRect = $ColorRect

enum PAGE {
    HOME,
    CHARACTER_PANEL,
    INVENTORY,
    SKILL_TREE,
    SKILLS_PANEL,
    SETTING,
    STORE,
    DUNGEON,
    FORGE,
}

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)
    EventBus.show_popup.connect(show_popup)
    EventBus.new_drop_item.connect(new_drop_item)
    EventBus.player_ability_change.connect(build_ability_ui)
    EventBus.player_dead.connect(update_ui)
    EventBus.show_damage_number.connect(func(_pos:Vector2, _text:String, _crit = false):
        var _damage_label:Label = Builder.build_a_damage_label()
        _damage_label.position = _pos
        _damage_label.text = _text
        _damage_label.crit = _crit
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
    EventBus.show_animation.connect(show_animation)
    
    backed_to_home.connect(func():quest_panel.show())
    changed_to_other.connect(func():quest_panel.hide())
    
    inventory_btn.pressed.connect(change_page.bind(PAGE.INVENTORY))
    character_btn.pressed.connect(change_page.bind(PAGE.CHARACTER_PANEL))
    setting_btn.pressed.connect(change_page.bind(PAGE.SETTING))
    skill_tree_btn.pressed.connect(change_page.bind(PAGE.SKILL_TREE))
    skills_panel_btn.pressed.connect(change_page.bind(PAGE.SKILLS_PANEL))
    store_btn.pressed.connect(change_page.bind(PAGE.STORE))
    dungeon_btn.pressed.connect(change_page.bind(PAGE.DUNGEON))
    forge_btn.pressed.connect(change_page.bind(PAGE.FORGE))
    # 添加技能
    get_skill_btn.pressed.connect(func():
        var _ability:FlowerAbility = Master.get_random_ability()
#        EventBus.player_get_a_ability.emit(_ability)
        EventBus.unlocked_ability.emit(_ability.id)
        EventBus.show_popup.emit("解锁技能", "解锁技能：%s" % _ability.name)
        )
    %GetFreeBtn.pressed.connect(func():
        Master.player.global_position = Vector2(0, 0)
        )
    %GetEquipmentBtn.pressed.connect(func():
        var _drop_item:InventoryItem = $Control/GetEquipmentBtn/ItemGenerator.gen_a_item()
        EventBus.new_drop_item.emit(_drop_item, Vector2(0, 0))
        )
    
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
            dungeon_ui.hide()
            forge_room.hide()
            backed_to_home.emit()
        PAGE.CHARACTER_PANEL:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.show()
            store_ui.hide()
            changed_to_other.emit()
            forge_room.hide()
            dungeon_ui.hide()
        PAGE.INVENTORY:
            skill_tree_ui.hide()
            inventory_ui.show()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.hide()
            changed_to_other.emit()
            forge_room.hide()
            dungeon_ui.hide()
        PAGE.SKILL_TREE:
            skill_tree_ui.show()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.hide()
            changed_to_other.emit()
            forge_room.hide()
            dungeon_ui.hide()
        PAGE.SETTING:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.show()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.hide()
            dungeon_ui.hide()
            forge_room.hide()
            changed_to_other.emit()
        PAGE.SKILLS_PANEL:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.show()
            character_panel_ui.hide()
            store_ui.hide()
            dungeon_ui.hide()
            forge_room.hide()
            changed_to_other.emit()
        PAGE.STORE:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.show()
            dungeon_ui.hide()
            forge_room.hide()
            changed_to_other.emit()
        PAGE.FORGE:
            skill_tree_ui.hide()
            inventory_ui.hide()
            setting_ui.hide()
            skills_panel_ui.hide()
            character_panel_ui.hide()
            store_ui.hide()
            dungeon_ui.hide()
            forge_room.show()
            changed_to_other.emit()
        PAGE.DUNGEON:
            if Master.in_dungeon:
                return
            dungeon_ui.show_popup()
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
    level_label.text = "Lv.%s" % str(Master.player_data.level)
    level_level_label.text = "第 %s 关" % str(Master.current_level)
    mp_bar.value = (float(Master.player_data.magic) / float(Master.player_data.max_magic)) * 100.0
    hp_bar.value = (float(Master.player_data.hp) / float(Master.player_data.max_hp)) * 100.0
    xp_bar.value = (float(Master.player_data.now_xp) / float(Master.player_data.next_level_xp)) * 100.0
    player_name_label.text = Master.player_name

func new_drop_item(_item:InventoryItem, _pos:Vector2) -> void:
    var _new_sprite:Node2D = Builder.build_a_drop_item()
    _new_sprite.set_item(_item)
    _new_sprite.global_position = _pos
    
    if _pos.x >= 1080:
        _pos.x = 600
    if _pos.y >= 1920:
        _pos.y = 800
    
    Master.world.add_child(_new_sprite)
    #EventBus.update_inventory.emit()

func show_color_rect() -> void:
    color_rect.show()

func hide_color_rect() -> void:
    color_rect.hide()

func show_animation(_key:String, _info:Dictionary = {}) -> void:
    if _key == "LevelUp":
        SoundManager.play_sound(load(Master.HAPPY_SOUNDS),  "GameBus")
        var _img:Control = load("res://Scene/UI/LevelUpAnimation.tscn").instantiate()
        add_child(_img)
    if _key == "PropertyContrast":
        SoundManager.play_sound(load(Master.HAPPY_SOUNDS),  "GameBus")
        var _img:Control = load("res://Scene/UI/PropertyContrast.tscn").instantiate()
        add_child(_img)
        _img.show_animation(_info)

func new_tip(_text:String) -> void:
    var _n = load("res://Scene/UI/Tips.tscn").instantiate()
    _n.text = _text
    add_child(_n)

func show_popup(_title:String, _desc:String, _show_cancel_btn:bool = false, _yes_event:Callable = func():,
 _cancel_event:Callable = func():) -> void:
    hide_color_rect()
    SoundManager.play_ui_sound(load(Master.POPUP_SOUNDS))
    var _popup:Panel = Builder.build_a_popup()
    
    _popup.closed.connect(func():hide_color_rect())
    
    _popup.title = _title
    _popup.desc = _desc
    _popup.show_cancel_btn = _show_cancel_btn
    _popup.yes_event = _yes_event
    _popup.cancel_event = _cancel_event
    
    add_child(_popup)
