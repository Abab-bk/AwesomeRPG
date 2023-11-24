extends Control

@onready var level_label:Label = %LevelLabel
@onready var player_name_label:Label = %PlayerNameLabel

@onready var title_bar:MarginContainer = $Panel/VBoxContainer/TitleBar


var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)

func _ready() -> void:
    title_bar.cancel_callable = cancel_event
    visibility_changed.connect(func():
        level_label.text = str(Master.player_output_data.level)
        player_name_label.text = Master.player_name
        )
