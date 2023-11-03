extends Control

@onready var stores:Control = %Stores
@onready var cancel_btn:Button = %CancelBtn

func _ready() -> void:
    cancel_btn.pressed.connect(func():
        hide()
        owner.change_page(0)
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        )
    
    visibility_changed.connect(func():
        if visible:
            for i in stores.get_children():
                i.update_ui()
        )
