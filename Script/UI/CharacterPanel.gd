extends Control

@onready var cancel_btn:Button = %CancelBtn
@onready var level_label:Label = %LevelLabel
@onready var player_name_label:Label = %PlayerNameLabel

func _ready() -> void:
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        owner.change_page(owner.PAGE.HOME))
    visibility_changed.connect(func():
        level_label.text = str(Master.player_output_data.level)
        player_name_label.text = Master.player_name
        )
