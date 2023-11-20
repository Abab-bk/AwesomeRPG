extends Control

var world := preload("res://Scene/World.tscn")

@onready var start_btn:Button = %StartBtn
@onready var exit_btn:Button = %ExitBtn

@onready var save_panel:Panel = $SavePanel

@onready var save_title_bar:MarginContainer = %SaveTitleBar
@onready var save_panels:VBoxContainer = %SavePanels


var hide_save_panel:Callable = func():
    save_panel.hide()

func _ready() -> void:
    save_title_bar.cancel_callable = hide_save_panel
    
    start_btn.pressed.connect(func():
        save_panel.show()
        )
    exit_btn.pressed.connect(func():
        get_tree().quit()
        )
    for i in save_panels.get_children():
        i.enter.connect(func():
            get_tree().change_scene_to_packed(world)
            )
