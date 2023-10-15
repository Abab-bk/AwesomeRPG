extends Control

@onready var items_ui:GridContainer = $Panel/VBoxContainer/GridContainer
@onready var cancel_btn:Button = %CancelBtn
@onready var slots_ui:GridContainer = %Slots

@export var inventory:Inventory

# TODO: 实现装备装备

func _ready() -> void:
    EventBus.update_inventory.connect(update_ui)
    EventBus.add_item.connect(func(_item:InventoryItem):
        inventory.add_item(_item))
    EventBus.equipment_up_ok.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            for i in slots_ui.get_children():
                if not i.current_equipment_type == _type:
                    return
                
                # 装备
                inventory.add_item(i.item)
                i.set_item(_item)
                inventory.remove_item(_item)
                
                EventBus.change_item_tooltip_state.emit(null)
                
                update_ui()
            )
    EventBus.equipment_down_ok.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            inventory.add_item(_item)
            EventBus.change_item_tooltip_state.emit(null)
            update_ui()
            )
    
    cancel_btn.pressed.connect(func():hide())
    
    set_bag()
    update_ui()

func set_bag() -> void:
    for i in inventory.size:
        var _n = Builder.builder_a_inventory_item()
        items_ui.add_child(_n)

func update_ui() -> void:    
    for item in inventory.items:
        var item_ui = items_ui.get_child(inventory.items.find(item))
        item_ui.item = item
        item_ui.update_ui()
         
