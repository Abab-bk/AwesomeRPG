extends Control

@onready var items:VBoxContainer = %Items
@onready var color_rect:ColorRect = $ColorRect
@onready var friends_inventory_ui:Control = %FriendsInventory

var current_friends:Dictionary = {}
var friends_inventory:Array[int] = [1001, 1002]

func _ready() -> void:
    friends_inventory_ui.closed.connect(func():color_rect.hide())
    
    for i in items.get_children():
        i.change_btn_click.connect(show_select_friends_panel.bind(i))
        i.changed.connect(func(_ui_id:int, _id:int):
            current_friends[_ui_id] = _id
            EventBus.changed_friends.emit(current_friends)
            )
    
    EventBus.save.connect(func():
        FlowerSaver.set_data("friends_current_friends", current_friends)
        )
    EventBus.load_save.connect(func():
        if not FlowerSaver.has_key("friends_current_friends"):
            return
        
        current_friends = FlowerSaver.get_data("friends_current_friends")
        
        for _node in items.get_children():
            if _node.id in current_friends.keys():
                if current_friends[_node.id] == -1:
                    continue
                _node.data = Master.get_friend_data_by_id(current_friends[_node.id])
                _node.update_ui()
        EventBus.changed_friends.emit(current_friends)
        )
    
    color_rect.hide()
    
    friends_inventory_ui.gen_friends(friends_inventory)
    
    update_ui()
    
func update_ui() -> void:
    for i in items.get_children():
        i.update_ui()

func show_select_friends_panel(_target_item_ui:Panel) -> void:
    friends_inventory_ui.target_item_ui = _target_item_ui
    friends_inventory_ui.gen_friends(friends_inventory)
    color_rect.show()
    
