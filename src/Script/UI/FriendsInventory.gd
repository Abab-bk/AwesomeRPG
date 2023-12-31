extends Control

signal selected_friend(firend:FriendData)
signal closed

@export var target_item_ui:Panel
@export var target_panel:Panel

@onready var title_bar:MarginContainer = %TitleBar
@onready var items:VBoxContainer = %Items

var cancel_callable:Callable = func():
    closed.emit()
    SoundManager.play_sound(load(Master.CLICK_SOUNDS))


func _ready() -> void:
    title_bar.cancel_callable = cancel_callable


# _firends_data: {id: resource}
func gen_friends(_firends_data:Dictionary) -> void:
    for i in items.get_children():
        i.queue_free()
    
    for _id in _firends_data.keys():
        if _id == -1:
            continue

        #判断当前伙伴是不是已经装上了
        # if target_panel.current_friends.size() >= 1:
        #    for _ui_id in target_panel.current_friends.keys():
        #        if not _id in target_panel.current_friends[_ui_id]:
        #            var _child = load("res://Scene/UI/SelectFriendItem.tscn").instantiate()
        #            items.add_child(_child)
        #            _child.data = _firends_data[_id]
        #            _child.selected.connect(func(_data:FriendData):
        #                selected_friend.emit(_data)
        #                closed.emit()
        #                target_item_ui.data = _data
        #                )
        #        else:
        #            continue
            
        var _child = load("res://Scene/UI/SelectFriendItem.tscn").instantiate()
        items.add_child(_child)
        _child.data = _firends_data[_id]
        _child.selected.connect(
            func(_data:FriendData):
                selected_friend.emit(_data)
                closed.emit()
                target_item_ui.data = _data
                )    
