extends Control

@onready var title_label:Label = %TitleLabel
@onready var content_label:RichTextLabel = %ContentLabel
@onready var fly_btn:Button = %FlyBtn

var need_coins:int

func _ready() -> void:
    fly_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        
        if Master.coins < need_coins:
            EventBus.new_tips.emit("金币不足")
            return
        
        if Master.player_output_data.level < 70:
            EventBus.new_tips.emit("等级不足")
            return
        
        Master.coins -= need_coins
        
        EventBus.show_popup.emit("飞升", "确认飞升吗？", true, func():
            Master.fly_count += 1
            Master.flyed_just_now = true
            #EventBus.flyed.emit()
            owner.change_page(owner.PAGE.HOME)
            EventBus.save.emit()
            await FlowerSaver.save_ok
            #EventBus.load_save.emit()
            #FlowerLoader.change_scene(Master.world, "res://Scene/Game/FlyAnimation.tscn")
            get_tree().change_scene_to_packed(load("res://Scene/Game/FlyAnimation.tscn"))
            #EventBus.change_scene.emit(Master.world, "res://Scene/Game/FlyAnimation.tscn")
            )
        )
    
    visibility_changed.connect(func():
        if not visible:
            return
        
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
达到 %s 级
%s 金币
你会获得：
击败怪物获得经验 +0.1 倍。[/center]
        """ % [str(Master.fly_count), "70", str(need_coins)]
        )
    
    fly_btn.hide()
    
    await get_tree().create_timer(3.0).timeout
    
    fly_btn.show()
    
    if FlowerSaver.has_key("flyed_just_now"):
        if FlowerSaver.get_data("flyed_just_now") == true:
            Master.flyed_just_now = false
