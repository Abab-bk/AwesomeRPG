extends Control

@onready var repo_items_ui:GridContainer = %RepoItems
@onready var inventory_items_ui:GridContainer = %InventoryItems
@onready var title_bar:MarginContainer = $Panel/VBoxContainer/TitleBar

@export var repo:Inventory
var inventory:Inventory

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)


func _ready() -> void:
    inventory = Master.player_inventory
    
    gen_slots()
    
    EventBus.move_item.connect(func(_item:InventoryItem):
        if _item in Master.player_inventory.items:
            move_item(_item, "Repo")
            return
        if _item in repo.items:
            move_item(_item, "Inventory")
            return
        )
    visibility_changed.connect(update_ui)
    
    title_bar.cancel_callable = cancel_event


func move_item(_item:InventoryItem, _to:String) -> void:
    if _to == "Repo":
        EventBus.remove_item.emit(_item)
        repo.add_item(_item)
        update_ui()
        return
    
    if _to == "Inventory":
        EventBus.add_item.emit(_item)
        repo.remove_item(_item)
        update_ui()
        return


func gen_slots() -> void:
    for i in inventory.size:
        var _n = Builder.build_a_inventory_item()
        inventory_items_ui.add_child(_n)
        _n.press_mode = "move"
    
    for i in repo.size:
        var _n = Builder.build_a_inventory_item()
        repo_items_ui.add_child(_n)
        _n.press_mode = "move"


func update_ui() -> void:
    for item_index in inventory_items_ui.get_child_count():
        #item.clean()
        var _node = inventory_items_ui.get_child(item_index)
        _node.item = null
        
        if inventory.items.size() - 1 < item_index:
            _node.update_ui()
            break
        
        _node.item = inventory.items[item_index]
        _node.update_ui()
    
    for item_index in repo_items_ui.get_child_count():
        #item.clean()
        var _node = repo_items_ui.get_child(item_index)
        _node.item = null
        
        if repo.items.size() - 1 < item_index:
            _node.update_ui()
            break
        
        _node.item = repo.items[item_index]
        _node.update_ui()
