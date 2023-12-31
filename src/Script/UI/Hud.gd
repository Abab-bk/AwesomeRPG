extends CanvasLayer

signal changed_to_other
signal backed_to_home

@onready var mp_bar:TextureProgressBar = %MpBar
@onready var hp_bar:TextureProgressBar = %HpBar

@onready var xp_bar:ProgressBar = %XpBar

@onready var level_label:Label = %LevelLabel
@onready var level_level_label:Label = %LevelLevelLabel
@onready var player_name_label:Label = %PlayerNameLabel
@onready var next_lvel_tip_label:Label = %NextLvelTipLabel

@onready var pages:TabContainer = %Pages

@onready var item_tool_tip:Panel = $ItemToolTip
#@onready var item_tool_tip_2:Panel = $ItemToolTip2

@onready var inventory_btn:TextureButton = %InventoryBtn
@onready var character_btn:Button = %CharacterBtn
@onready var skill_tree_btn:TextureButton = %SkillTreeBtn
@onready var skills_panel_btn:TextureButton = %SillsPanelBtn
@onready var setting_btn:TextureButton = %SettingBtn
@onready var store_btn:TextureButton = %StoreBtn
@onready var dungeon_btn:TextureButton = %DungeonBtn
@onready var forge_btn:TextureButton = %ForgeBtn
@onready var repo_btn:TextureButton = %RepoBtn
@onready var days_checkin_btn:TextureButton = %"7DaysCheckinBtn"
@onready var fly_btn:TextureButton = %FlyBtn
@onready var friends_btn:TextureButton = %FriendsBtn
@onready var tower_btn:TextureButton = %TowerBtn
@onready var gacha_btn:TextureButton = %GachaBtn
@onready var every_day_quest_btn:TextureButton = %EveryDayQuestBtn
@onready var show_more_btn:TextureButton = %ShowMoreBtn
@onready var ranking_list_btn:TextureButton = %RankingListBtn

@onready var get_skill_btn:Button = %GetSkillBtn

@onready var inventory_ui:Control = $Pages/Pages/Inventory
@onready var character_panel_ui:Control = $Pages/Pages/CharacterPanel
@onready var skill_tree_ui:Control = $Pages/Pages/SkillTree
@onready var setting_ui:Control = $Pages/Pages/SettingUI
@onready var skills_panel_ui:Control = $Pages/Pages/SkillsPanel
@onready var quest_panel:Control = %QuestPanel
@onready var store_ui:Control = $Pages/Pages/StoreUI
@onready var dungeon_ui:Control = $Pages/Pages/DungeonPanel
@onready var forge_room:Control = $Pages/Pages/ForgeRoom
@onready var repository:Control = $Pages/Pages/Repository

@onready var level_up_arrow:Control = $LevelUpArrow
@onready var property_change_arrow:Control = $PropertyChangeArrow

@onready var animation_player = $AnimationPlayer

@onready var skill_bar:HBoxContainer = %SkillBar
@onready var color_rect:ColorRect = $BlackRect

@onready var days_checkin_red_point:TextureRect = %DaysCheckinRedPoint
@onready var every_day_quest_red_point:TextureRect = %EveryDayQuestRedPoint

var show_days_checkin_red_point:bool = true:
    set(v):
        show_days_checkin_red_point = v
        days_checkin_red_point.visible = show_days_checkin_red_point
        FlowerSaver.set_data("hud_show_days_checkin_red_point", show_days_checkin_red_point)
        
var show_every_day_quest_red_point:bool = true:
    set(v):
        show_every_day_quest_red_point = v
        every_day_quest_red_point.visible = show_every_day_quest_red_point
        FlowerSaver.set_data("hud_show_every_day_quest_red_point", show_every_day_quest_red_point)

var should_show_every_day_reward:bool = true:
    set(v):
        should_show_every_day_reward = v

        if should_show_every_day_reward:
            var _every_day_reward_panel:Control = load("res://Scene/UI/EveryDayReward.tscn").instantiate()
            add_child(_every_day_reward_panel)
        
        FlowerSaver.set_data("hud_should_show_every_day_reward", should_show_every_day_reward)

var _offline_level_up_get:bool = false

enum PAGE {
    HOME,
    INVENTORY,
    CHARACTER_PANEL,
    SKILL_TREE,
    SETTING,
    SKILLS_PANEL,
    STORE,
    FORGE,
    REPO,
    DAYS_CHICKIN,
    FLY,
    FRIENDS,
    TOWER,
    DUNGEON,
    GACHA,
    EVERY_DAY_QUEST,
    RANKING_LIST,
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
    EventBus.show_select_skills_panel.connect(func(_target:Panel):
        var _panel:Panel = Builder.build_a_select_sills_panel()
        _panel.target_skill_panel = _target
        add_child(_panel)
        )
    EventBus.show_color.connect(show_color_rect)
    EventBus.hide_color.connect(hide_color_rect)
    EventBus.new_tips.connect(new_tip)
    
    EventBus.player_level_up.connect(show_animation.bind("LevelUp"))
    EventBus.player_offline_level_up.connect(show_animation.bind("LevelUp", {}, true))
    EventBus.show_animation.connect(show_animation)
    
    EventBus.unlock_new_function.connect(func(_key:String):
        if _key == "talent_tree":
            skill_tree_ui.gen_trees_by_walker()
        )
    
    EventBus.get_talent_point.connect(func(_count:int):
        new_tip("获得 %s 技能点" % str(_count))
        )
    EventBus.build_and_show_friend_info_panel.connect(func(_friend_data:FriendData):
        var _new_node = load("res://Scene/UI/FriendPanel.tscn").instantiate()
        add_child(_new_node)
        _new_node.set_data(_friend_data)
        )
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("hud_show_every_day_quest_red_point"):
            show_every_day_quest_red_point = FlowerSaver.get_data("hud_show_every_day_quest_red_point")
        if FlowerSaver.has_key("hud_show_days_checkin_red_point"):
            show_days_checkin_red_point = FlowerSaver.get_data("hud_show_days_checkin_red_point")
        if FlowerSaver.has_key("hud_should_show_every_day_reward"):
            should_show_every_day_reward = FlowerSaver.get_data("hud_should_show_every_day_reward")
        )
    EventBus.show_every_day_quest_red_point.connect(func():
        show_every_day_quest_red_point = true
        )
    EventBus.set_should_show_reward_day_reward.connect(func(_state:bool):
        should_show_every_day_reward = _state
        )

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
    repo_btn.pressed.connect(change_page.bind(PAGE.REPO))
    days_checkin_btn.pressed.connect(func():
        show_days_checkin_red_point = false
        change_page(PAGE.DAYS_CHICKIN)
        )
    fly_btn.pressed.connect(change_page.bind(PAGE.FLY))
    friends_btn.pressed.connect(change_page.bind(PAGE.FRIENDS))
    tower_btn.pressed.connect(change_page.bind(PAGE.TOWER))
    gacha_btn.pressed.connect(change_page.bind(PAGE.GACHA))
    ranking_list_btn.pressed.connect(change_page.bind(PAGE.RANKING_LIST))
    every_day_quest_btn.pressed.connect(func():
        show_every_day_quest_red_point = false
        change_page(PAGE.EVERY_DAY_QUEST)
        )
    
    show_more_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        if show_more_btn.button_pressed:
            animation_player.play("show_sub_function")
        else:
            animation_player.play_backwards("show_sub_function")
        )
    
    # 添加技能
    get_skill_btn.pressed.connect(func():
        var _ability:FlowerAbility = Master.get_random_ability()
#        EventBus.player_get_a_ability.emit(_ability)
        EventBus.unlocked_ability.emit(_ability.id)
        EventBus.show_popup.emit("解锁技能", "解锁技能：%s" % _ability.name)
        )
    %GetFreeBtn.pressed.connect(func():
        Master.player.global_position = Vector2(0, 0)
        Master.player.current_state = Player.STATE.IDLE
        )
    %GetEquipmentBtn.pressed.connect(func():
        var _drop_item:InventoryItem = $Control/GetEquipmentBtn/ItemGenerator.gen_a_item(true)
        EventBus.new_drop_item.emit(_drop_item, Vector2(0, 0))
        )
    
    build_ability_ui()
    
    hide_color_rect()
    update_ui()
    change_page(PAGE.HOME)
    
    if TimeManager.is_next_day(Master.last_leave_time):
        show_days_checkin_red_point = true
        show_every_day_quest_red_point = true
        should_show_every_day_reward = true
    
    # if should_show_every_day_reward:
    #     var _every_day_reward_panel:Control = load("res://Scene/UI/EveryDayReward.tscn").instantiate()
    #     add_child(_every_day_reward_panel)


func change_page(_page:PAGE) -> void:
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    
    if _page == 0:
        EventBus.change_item_tooltip_state.emit(null)
        %HealingItemsBar.show()
    
    pages.current_tab = int(_page)
    %HealingItemsBar.show()

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
    if not Master.player_output_data:
        return
    
    level_label.text = "Lv.%s" % str(Master.player_output_data.level)
    
    if Master.current_location == Const.LOCATIONS.WORLD:
        level_level_label.text = "第 %s 关" % str(Master.current_level)
        next_lvel_tip_label.text = "余剩：%s 只怪物" % str(Master.next_level_need_kill_count)
    elif Master.current_location == Const.LOCATIONS.TOWER:
        level_level_label.text = "第 %s 层" % str(Master.current_tower_level)
        next_lvel_tip_label.text = "余剩：%s 只怪物" % str(Master.need_kill_enemys_to_next_tower)
    
    mp_bar.value = (float(Master.player_output_data.magic) / float(Master.player_output_data.max_magic)) * 100.0
    hp_bar.value = (float(Master.player_output_data.hp) / float(Master.player_output_data.max_hp)) * 100.0
    xp_bar.value = (float(Master.player_output_data.now_xp) / float(Master.player_output_data.next_level_xp)) * 100.0
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


func show_animation(_key:String, _info:Dictionary = {}, _offline_sound:bool = false) -> void:
    if _key == "LevelUp":
        if _offline_sound:
            if _offline_level_up_get:
                return
            _offline_level_up_get = true
        
        for i in level_up_arrow.get_children():
            i.queue_free()
        
        # SoundManager.play_ui_sound(load(Master.HAPPY_SOUNDS),  "GameBus")
        SoundManager.play_ui_sound(load(Const.SOUNDS.WindUp))
        
        var _img:Control = load("res://Scene/UI/LevelUpAnimation.tscn").instantiate()
        level_up_arrow.add_child(_img)
    
    if _key == "PropertyContrast":
        for i in property_change_arrow.get_children():
            i.queue_free()
        
        var _img:Control = load("res://Scene/UI/PropertyContrast.tscn").instantiate()
        property_change_arrow.add_child(_img)
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

