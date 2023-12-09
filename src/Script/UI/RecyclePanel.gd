extends ColorRect

@onready var filter:VBoxContainer = %Filter
@onready var yes_btn:Button = %YesBtn
@onready var cancel_btn:Button = %CancelBtn

var _types:Array[int] = []
var wait_to_remove_items:Array[InventoryItem] = []

func _ready() -> void:
    for i in filter.get_children():
        i.toggled.connect(func(_pressed:bool):
            if _pressed:
                _types.append(Const.EQUIPMENT_QUALITY[i.name])
                return
            _types.erase(Const.EQUIPMENT_QUALITY[i.name])
            )
    
    yes_btn.pressed.connect(func():
        for _type in _types:
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
            EventBus.recycle_equipment.emit()
            Master.player_inventory.remove_item(i)
        
        wait_to_remove_items = []
        
        EventBus.update_inventory.emit()
        )
    
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        queue_free()
        )

