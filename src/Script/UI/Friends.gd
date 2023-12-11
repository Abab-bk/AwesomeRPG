extends Control

@onready var items:VBoxContainer = %Items
@onready var color_rect:ColorRect = $SelectFriend
@onready var friends_inventory_ui:Control = %FriendsInventory

#@onready var all_friends:GridContainer = %AllFriends

# ui_id: friend_id
var current_friends:Dictionary = {}:
    set(v):
        current_friends = v
        save()


func _ready() -> void:
    friends_inventory_ui.closed.connect(func():color_rect.hide())
    
    for i in items.get_children():
        i.change_btn_click.connect(show_select_friends_panel.bind(i))
        i.changed.connect(func(_ui_id:int, _data:FriendData):
            current_friends[_ui_id] = _data.id
            EventBus.changed_friends.emit(current_friends)
            save()
            )
    
    EventBus.load_save.connect(func():
        if not FlowerSaver.has_key("friends_current_friends"):
            return
        
        if FlowerSaver.has_key("friends_inventory_inventory"):
            Master.friends_inventory = FlowerSaver.get_data("friends_inventory_inventory")        
        if FlowerSaver.has_key("friends_current_friends"):
            current_friends = FlowerSaver.get_data("friends_current_friends")
        
        for _node in items.get_children():
            if _node.id in current_friends.keys():
                if current_friends[_node.id] == null:
                    continue
                _node.data = Master.friends_inventory[current_friends[_node.id]]
                _node.update_ui()
        
        EventBus.changed_friends.emit(current_friends)
        )
    
    EventBus.get_friend.connect(func(_id):
        if not _id in Master.friends_inventory:
            Master.friends_inventory[_id] = Master.get_friend_data_by_id(_id)
            save()
            return
            
        if Master.friends_inventory[_id] == null:
            Master.friends_inventory[_id] = Master.get_friend_data_by_id(_id)
            save()
            return
            
        save()
        )
    
    color_rect.hide()
    
    friends_inventory_ui.gen_friends(Master.friends_inventory)
    
    update_ui()


func save() -> void:
    Tracer.info("玩家随从背包保存")
    FlowerSaver.set_data("friends_current_friends", current_friends)
    FlowerSaver.set_data("friends_inventory_inventory", Master.friends_inventory)


func update_ui() -> void:
    for i in items.get_children():
        i.update_ui()


func show_select_friends_panel(_target_item_ui:Panel) -> void:
    friends_inventory_ui.target_item_ui = _target_item_ui
    friends_inventory_ui.gen_friends(Master.friends_inventory)
    color_rect.show()
    
