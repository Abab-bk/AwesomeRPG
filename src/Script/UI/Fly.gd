extends Control

@onready var title_label:Label = %TitleLabel
@onready var content_label:RichTextLabel = %ContentLabel
@onready var fly_btn:Button = %FlyBtn
@onready var lock_label:Label = $Panel/VBoxContainer/LockLabel
@onready var content:TextureRect = $Panel/VBoxContainer/Content

var need_coins:int


func _ready() -> void:
    fly_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        
        if Master.coins < need_coins:
            EventBus.new_tips.emit("金币不足")
            return
        
        EventBus.show_popup.emit("飞升", "确认飞升吗？", true, func():
            # 重生目的：解锁最大等级、点飞升技能树 -> 更快变强
            # 获得技能点公式：根据玩家当前的所有属性
            Master.flyed_skill_point += get_flyed_skill_point_count()
            Master.coins -= need_coins
            Master.fly_count += 1
            Master.flyed_just_now = true
            #EventBus.flyed.emit()
            owner.change_page(owner.PAGE.HOME)
            EventBus.save.emit()
            await FlowerSaver.save_ok
            #EventBus.load_save.emit()
            #get_tree().change_scene_to_packed(load("res://Scene/Game/FlyAnimation.tscn"))
            get_tree().change_scene_to_packed(load("res://Scene/UI/FlyedSkillTree.tscn"))
            )
        )
    
    EventBus.unlock_new_function.connect(func(_key:String):
        if _key == "fly":
            lock_label.hide()
            content.show()
        )
    
    visibility_changed.connect(func():
        if not visible:
            return
        
        update_ui()
        var _level:int = max(1, Master.player.get_level() - 10)
        need_coins = floor((_level * randi_range(0, 5)) * 80)
        
        content_label.text = """
[center]
（已飞升：%s 次）
你已经洞察了世间的无常。
想要飞升吗？
你会失去：
一切。
你需要：
%s 金币
你会获得：
击败怪物获得经验 +0.1 倍。
玩家最大等级 +10.
%s 点飞天赋点。
[/center]
        """ % [str(Master.fly_count), str(need_coins), str(get_flyed_skill_point_count())]
        )
    
    update_ui()
    
    if FlowerSaver.has_key("flyed_just_now"):
        if FlowerSaver.get_data("flyed_just_now") == true:
            Master.flyed_just_now = false


func update_ui() -> void:
    if not Master.unlocked_functions.has("fly"):
        return
    if Master.unlocked_functions["fly"]:
        lock_label.hide()
        content.show()
    else:
        lock_label.show()
        content.hide()


func get_flyed_skill_point_count() -> int:
    return int(get_player_all_stat() / 100) + 3


func get_player_all_stat() -> float:
    var _result:float = 0.0
    
    #_result += Master.player_data.max_hp
    #_result += Master.player_data.max_magic
    _result += Master.player_data.strength
    _result += Master.player_data.agility
    _result += Master.player_data.wisdom
    
    return _result