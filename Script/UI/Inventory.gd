extends Control

@onready var items_ui:GridContainer = %Items
@onready var slots_ui_1:VBoxContainer = %SlotsUI1
@onready var slots_ui_2:VBoxContainer = %SlotsUI2

@onready var title_bar:MarginContainer = $Panel/MarginContainer/VBoxContainer/TitleBar

@onready var recycle_btn:Button = %RecycleBtn
@onready var auto_recycle_btn:Button = %AutoRecycleBtn

@onready var active_check_box:CheckBox = %ActiveCheckBox

@onready var auto_recycle_panel:Panel = $AutoRecyclePanel

@onready var filter:VBoxContainer = %Filter

@export var inventory:Inventory:
    set(v):
        inventory = v
        Master.player_inventory = inventory

var slots:Array[Panel]

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)

var auto_recycle_is_active:bool = false
var auto_recycle_targets:Array[Const.EQUIPMENT_QUALITY] = []

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
        FlowerSaver.set_data("inventory_auto_recycle_setting", {
            "active": auto_recycle_is_active,
            "targets": auto_recycle_targets
        })
        )
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("flyed_just_now"):
            if FlowerSaver.get_data("flyed_just_now") == true:
                return
        
        inventory = FlowerSaver.get_data("inventory", Master.current_save_slot)
        Master.player_inventory = inventory
        
        if FlowerSaver.has_key("inventory_auto_recycle_setting"):
            auto_recycle_is_active = FlowerSaver.get_data("inventory_auto_recycle_setting")["active"]
            auto_recycle_targets = FlowerSaver.get_data("inventory_auto_recycle_setting")["targets"]        
        update_ui()
        )
    
    for i in filter.get_children():
        i.toggled.connect(func(_pressed:bool):
            if _pressed:
                auto_recycle_targets.append(Const.EQUIPMENT_QUALITY[i.name])
                return
            auto_recycle_targets.erase(Const.EQUIPMENT_QUALITY[i.name])
            )
    
    active_check_box.toggled.connect(func(_pressed:bool):
        auto_recycle_is_active = _pressed
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
    
    auto_recycle_btn.pressed.connect(func():
        auto_recycle_panel.show()
        )
    
    %CancelBtn.pressed.connect(func():
        auto_recycle_panel.hide()
        )
    
    auto_recycle_panel.hide()
    
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

    if inventory.items.size() >= inventory.size - 10 and auto_recycle_is_active:
        var wait_to_remove_items:Array[InventoryItem]
        
        for _type in auto_recycle_targets:
            for _item in Master.player_inventory.items:
                if not _item:
                    #print("装备无效")
                    continue
                
                if not _item.quality == _type:
                    #print("稀有度不对")
                    continue
                
                Master.coins += _item.price
                wait_to_remove_items.append(_item)
        
        var _count:int = 0
        for i in wait_to_remove_items:
            _count += 1
            Master.player_inventory.remove_item(i)
        
        wait_to_remove_items = []
        
        EventBus.update_inventory.emit()
