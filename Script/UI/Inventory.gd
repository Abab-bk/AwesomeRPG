extends Control

@onready var items_ui:GridContainer = %Items
@onready var slots_ui_1:VBoxContainer = %SlotsUI1
@onready var slots_ui_2:VBoxContainer = %SlotsUI2

@onready var title_bar:MarginContainer = $Panel/MarginContainer/VBoxContainer/TitleBar

@onready var recycle_btn:Button = %RecycleBtn

@export var inventory:Inventory:
    set(v):
        inventory = v
        Master.player_inventory = inventory

var slots:Array[Panel]

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)

func _ready() -> void:
    for i in slots_ui_1.get_children():
        slots.append(i)
    for i in slots_ui_2.get_children():
        slots.append(i)
    
    EventBus.update_inventory.connect(update_ui)
    
    EventBus.add_item.connect(func(_item:InventoryItem):
        inventory.add_item(_item)
        update_ui()
        )
    EventBus.remove_item.connect(func(_item:InventoryItem):
        inventory.remove_item(_item))
    
    #EventBus.equipment_up_ok.connect(
        #func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            #for i in slots:
                ## 如果装备类型不匹配，进入下一次循环
                #if not i.current_equipment_type == _type:
                    #continue
                #
                ## 装备
                #i.set_item(_item)
                ##inventory.remove_item(_item)
                #
                #EventBus.change_item_tooltip_state.emit(null)
                #
                #update_ui()
            #)
    EventBus.equipment_down_ok.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            inventory.add_item(_item)
            EventBus.change_item_tooltip_state.emit(null)
            update_ui()
            )
    EventBus.save.connect(func():
        FlowerSaver.set_data("inventory", inventory)
        )
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("flyed_just_now"):
            if FlowerSaver.get_data("flyed_just_now") == true:
                return
                
        inventory = FlowerSaver.get_data("inventory", Master.current_save_slot)
        Master.player_inventory = inventory
        update_ui()
        )
    
    title_bar.cancel_callable = cancel_event
    
    visibility_changed.connect(func():
        if visible:
            update_ui()
        )
    
    recycle_btn.pressed.connect(func():
        var _panel:ColorRect = Builder.build_a_recycle_panel()
        add_child(_panel)
        )
    
    Master.player_inventory = inventory
    
    set_bag()
    update_ui()

func set_bag() -> void:
    for i in inventory.size:
        var _n = Builder.build_a_inventory_item()
        items_ui.add_child(_n)

func update_ui() -> void:
    for item_index in items_ui.get_child_count():
        var _node = items_ui.get_child(item_index)
        _node.item = null
        _node.update_ui()

    for item_index in items_ui.get_child_count():
        var _node = items_ui.get_child(item_index)
        
        if inventory.items.size() - 1 < item_index:    
            return
        
        _node.item = inventory.items[item_index]
        _node.update_ui()
