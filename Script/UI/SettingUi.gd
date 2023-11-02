extends Control

@onready var cancel_btn:Button = %CancelBtn

func _ready() -> void:
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        owner.change_page(owner.PAGE.HOME)
        )
