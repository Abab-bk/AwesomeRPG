extends Control

@onready var title_label:Label = %TitleLabel
@onready var content_label:RichTextLabel = %ContentLabel
@onready var fly_btn:Button = %FlyBtn

func _ready() -> void:
    fly_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
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
    
    fly_btn.hide()
    
    await get_tree().create_timer(3.0).timeout
    
    fly_btn.show()
    
    if FlowerSaver.has_key("flyed_just_now"):
        if FlowerSaver.get_data("flyed_just_now") == true:
            Master.flyed_just_now = false
