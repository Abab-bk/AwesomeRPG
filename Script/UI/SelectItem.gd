extends MarginContainer

@export var forge_room:Control

@onready var title_bar:MarginContainer = %STitleBar

@onready var yes_btn:Button = %SYesBtn
@onready var items_ui:GridContainer = %SItems

var selected_item:InventoryItem

var cancel_event:Callable = func():hide()

func _ready() -> void:    
    set_bag()
    update_ui()
    
    title_bar.cancel_callable = cancel_event
    
    visibility_changed.connect(func():
        if visible:
            update_ui()
        else:
            EventBus.change_item_tooltip_state.emit(null)
        )
    yes_btn.pressed.connect(func():
        # 现在拿到的并非原来的实例
        forge_room.current_item = selected_item.duplicate(true)
        # 现在拿到的是原来的实例
        forge_room.ture_item = selected_item
        hide()
        )
    

func set_bag() -> void:
    for i in Master.player_inventory.size:
        var _n = Builder.build_a_inventory_item()
        items_ui.add_child(_n)
        _n.press_mode = "display"
        
        _n.pressed.connect(func(_item):
            selected_item = _item
            )

func update_ui() -> void:
    for item_index in items_ui.get_child_count():
        #item.clean()
        var _node = items_ui.get_child(item_index)
        _node.item = null
        
        if Master.player_inventory.items.size() - 1 < item_index:
            _node.update_ui()
            return
        
        _node.item = Master.player_inventory.items[item_index]
        _node.update_ui()
        
