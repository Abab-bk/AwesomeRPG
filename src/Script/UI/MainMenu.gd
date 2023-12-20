extends Control

var world := preload("res://Scene/World.tscn")

@onready var start_btn:Button = %StartBtn
@onready var exit_btn:Button = %ExitBtn
@onready var credits_cancel_btn:Button = %CreditsCancelBtn
@onready var credits_btn:Button = %CreditsBtn

@onready var save_panel:Panel = $SavePanel
@onready var credits_panel:Panel = $Credits

@onready var creat_character:Control = $CreatCharacter

@onready var save_title_bar:MarginContainer = %SaveTitleBar
@onready var save_panels:VBoxContainer = %SavePanels

var hide_save_panel:Callable = func():
    save_panel.hide()

func _ready() -> void:
    save_title_bar.cancel_callable = hide_save_panel
    
    save_panel.hide()
    creat_character.hide()
    
    creat_character.creat_ok.connect(func():
        get_tree().change_scene_to_packed(load("res://Scene/UI/StartCut.tscn"))
        )
    start_btn.pressed.connect(func():
        save_panel.show()
        )
    exit_btn.pressed.connect(func():
        get_tree().quit()
        )
    
    credits_btn.pressed.connect(func():
        credits_panel.show()
        )
    credits_cancel_btn.pressed.connect(func():
        credits_panel.hide()
        )
    
    for i in save_panels.get_children():
        i.enter_game.connect(func():
            get_tree().change_scene_to_packed(world)
            )
        i.enter_creat.connect(func():
            creat_character.show()
            )
    
    SoundManager.play_music(load(Const.SOUNDS.BGM))
