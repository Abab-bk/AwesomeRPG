extends Control

signal selected_friend(firend:FriendData)
signal closed

@export var target_item_ui:Panel

@onready var title_bar:MarginContainer = %TitleBar
@onready var items:VBoxContainer = %Items

var cancel_callable:Callable = func():
    closed.emit()
    SoundManager.play_sound(load(Master.CLICK_SOUNDS))

func _ready() -> void:
    title_bar.cancel_callable = cancel_callable


func gen_friends(_firends_data:Dictionary) -> void:
    for i in items.get_children():
        i.queue_free()
    
    for _id in _firends_data.keys():
        if _id == -1:
            continue
        
        var _child = load("res://Scene/UI/SelectFriendItem.tscn").instantiate()
        items.add_child(_child)
        _child.data = _firends_data[_id]
        _child.selected.connect(func(_data:FriendData):
            selected_friend.emit(_data)
            closed.emit()
            target_item_ui.data = _data
            )
