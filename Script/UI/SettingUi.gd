extends Control

@onready var title_bar:MarginContainer = $Panel/MarginContainer/VBoxContainer/TitleBar

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)


func _ready() -> void:
    title_bar.cancel_callable = cancel_event
