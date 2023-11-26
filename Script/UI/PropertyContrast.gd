extends Control

@onready var items:VBoxContainer = %Items
@onready var button:Button = $Button

func _ready() -> void:
    button.pressed.connect(func():queue_free())

func show_animation(_data:Dictionary) -> void:
    print("第%次")
    for i in _data.keys():
        var _item:HBoxContainer = load("res://Scene/UI/PropertyUpArrow.tscn").instantiate()
        items.add_child(_item)
        _item.update_ui(i, _data[i])
