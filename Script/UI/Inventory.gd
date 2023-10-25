extends Control

@onready var slots_ui:GridContainer = %Slots
@onready var items_ui:GridContainer = %Items

@onready var cancel_btn:Button = %CancelBtn
@onready var recycle_btn:Button = %RecycleBtn

@export var inventory:Inventory

func _ready() -> void:
    EventBus.update_inventory.connect(update_ui)
    EventBus.add_item.connect(func(_item:InventoryItem):
        inventory.add_item(_item))
    EventBus.equipment_up_ok.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            for i in slots_ui.get_children():
                # 如果装备类型不匹配，进入下一次循环
                if not i.current_equipment_type == _type:
                    continue
                
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
    
    recycle_btn.pressed.connect(func():
        var _panel:ColorRect = Builder.build_a_recycle_panel()
        _panel.inventory = inventory
        add_child(_panel)
        )
    
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        hide()
        )
    
    set_bag()
    update_ui()

func set_bag() -> void:
    for i in inventory.size:
        var _n = Builder.build_a_inventory_item()
        items_ui.add_child(_n)

func update_ui() -> void:
    for item in items_ui.get_children():
        item.clean()
    
    for item in inventory.items:  
        var item_ui = items_ui.get_child(inventory.items.find(item))
        item_ui.item = item
        item_ui.update_ui()
         
