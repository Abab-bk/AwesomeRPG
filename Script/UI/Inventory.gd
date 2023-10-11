extends Control

@onready var items_ui:GridContainer = $Panel/VBoxContainer/GridContainer
@onready var cancel_btn:Button = %CancelBtn

@export var inventory:Inventory

func _ready() -> void:
    EventBus.update_inventory.connect(update_ui)
    EventBus.add_item.connect(func(_item:InventoryItem):
        inventory.add_item(_item))
    
    cancel_btn.pressed.connect(func():hide())
    
    set_bag()
    update_ui()

func set_bag() -> void:
    for i in inventory.size:
        var _n = Bulider.builder_a_inventory_item()
        items_ui.add_child(_n)

func update_ui() -> void:
    for item in inventory.items:
        var item_ui = items_ui.get_child(inventory.items.find(item))
        item_ui.item = item
        item_ui.update_ui()
            
