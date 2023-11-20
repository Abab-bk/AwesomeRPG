extends Control

@onready var title_label:Label = %TitleLabel
@onready var content_label:RichTextLabel = %ContentLabel
@onready var fly_btn:Button = %FlyBtn

func _ready() -> void:
    fly_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        EventBus.show_popup.emit("飞升", "确认飞升吗？", true, func():
            Master.fly_count += 1
            #EventBus.flyed.emit()
            owner.change_page(owner.PAGE.HOME)
            EventBus.change_scene.emit(Master.world, "res://Scene/Game/FlyAnimation.tscn")
            )
        )
