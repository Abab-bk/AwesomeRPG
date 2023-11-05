extends MarginContainer

@export var forge_room:Control

@onready var yes_btn:Button = %SYesBtn
@onready var cancel_btn:Button = %SCancelBtn
@onready var items_ui:GridContainer = %SItems

var inventory:Inventory
var selected_item:InventoryItem

func _ready() -> void:
    inventory = Master.player_inventory
    
    set_bag()
    update_ui()
    
    visibility_changed.connect(func():
        if visible:
            update_ui()
        )
    cancel_btn.pressed.connect(func():hide())
    yes_btn.pressed.connect(func():
        forge_room.current_item = selected_item
        hide()
        )
    

func set_bag() -> void:
    for i in inventory.size:
        var _n = Builder.build_a_inventory_item()
        items_ui.add_child(_n)
        _n.pressed.connect(func(_item):
            selected_item = _item
            )

func update_ui() -> void:
    for item in items_ui.get_children():
        item.clean()
    
    for item in inventory.items:  
        var item_ui = items_ui.get_child(inventory.items.find(item))
        item_ui.item = item
        item_ui.update_ui()
