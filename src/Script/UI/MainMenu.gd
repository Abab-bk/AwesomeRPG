extends Control

#var world := preload("res://Scene/World.tscn")

@onready var start_btn:Button = %StartBtn
@onready var exit_btn:Button = %ExitBtn
@onready var credits_cancel_btn:Button = %CreditsCancelBtn
@onready var credits_btn:Button = %CreditsBtn

@onready var save_panel:Panel = $SavePanel
@onready var credits_panel:Panel = $Credits

@onready var creat_character:Control = $CreatCharacter

@onready var save_title_bar:MarginContainer = %SaveTitleBar
@onready var save_panels:VBoxContainer = %SavePanels

@onready var yes_btn:Button = %YesBtn
@onready var cancel_btn:Button = %CancelBtn
@onready var color_rect:ColorRect = $ColorRect


var hide_save_panel:Callable = func():
    save_panel.hide()

var yes_event:Callable = func():
    pass

func _ready() -> void:
    save_title_bar.cancel_callable = hide_save_panel
    
    save_panel.hide()
    creat_character.hide()
    
    creat_character.creat_ok.connect(func():
        #get_tree().change_scene_to_packed(load("res://Scene/UI/StartCut.tscn"))
        #YASM.load_scene("res://Scene/UI/StartCut.tscn")
        #SceneLoader.load_scene(self, "start_cut")
        SceneManager.change_scene("res://Scene/UI/StartCut.tscn")        
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
    
    cancel_btn.pressed.connect(func():
        color_rect.hide()
        )
    
    yes_btn.pressed.connect(func():
        yes_event.call()
        color_rect.hide()
        )
    
    for i in save_panels.get_children():
        i.enter_game.connect(func():
            #get_tree().change_scene_to_packed(world)
            #YASM.load_scene("res://Scene/World.tscn")
            #SceneLoader.load_scene(self, "world")
            SceneManager.change_scene("res://Scene/World.tscn")
            )
        i.enter_creat.connect(func():
            creat_character.show()
            )
    
    color_rect.hide()
    
    SoundManager.play_music(load(Const.SOUNDS.BGM))
