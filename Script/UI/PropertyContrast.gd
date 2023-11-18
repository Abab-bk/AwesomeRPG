extends Control

@onready var items:VBoxContainer = %Items
@onready var button:Button = $Button

func _ready() -> void:
    button.pressed.connect(func():queue_free())

func show_animation(_data:Dictionary) -> void:
    for i in _data.keys():
        var _item:HBoxContainer = load("res://Scene/UI/PropertyUpArrow.tscn").instantiate()
        
        _item.data = _data[i]
        _item.title = i
        
        items.add_child(_item)
