extends Control

@onready var level_label:Label = %LevelLabel
@onready var button:Button = $Button
@onready var items:VBoxContainer = %Items

func _ready() -> void:
    level_label.text = str(Master.player_output_data.level)
    button.pressed.connect(func():queue_free())
    show_animation(Master.get_player_level_up_info())

func show_animation(_data:Dictionary) -> void:
    for i in _data.keys():
        var _item:HBoxContainer = load("res://Scene/UI/PropertyUpArrow.tscn").instantiate()
        
        items.add_child(_item)
        _item.update_ui(i, _data[i])
