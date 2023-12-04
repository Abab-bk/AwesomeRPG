extends Control

@onready var level_label:Label = %LevelLabel
@onready var player_name_label:Label = %PlayerNameLabel

@onready var title_bar:MarginContainer = $Panel/VBoxContainer/TitleBar
@onready var propertys:GridContainer = %Propertys


var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)

func _ready() -> void:
    title_bar.cancel_callable = cancel_event
    visibility_changed.connect(func():
        if not visible:
            return
        level_label.text = str(Master.player_output_data.level)
        player_name_label.text = Master.player_name
        #update_ui()
        )
    
func update_ui() -> void:
    for i in propertys.get_children():
        i.update_value()
