extends ColorRect

@onready var filter:VBoxContainer = %Filter
@onready var yes_btn:Button = %YesBtn
@onready var cancel_btn:Button = %CancelBtn

var inventory:Inventory

func _ready() -> void:
    var _types:Array[int] = []
        
    for i in filter.get_children():
        i.toggled.connect(func(_pressed:bool):
            if _pressed:
                _types.append(Const.EQUIPMENT_QUALITY[i.name])
                return
            _types.erase(Const.EQUIPMENT_QUALITY[i.name])
            )
    
    yes_btn.pressed.connect(func():
        # FIXME: 回收装备 - 不正常
        print(_types)
        for _type in _types:
            for _item in inventory.items:
                if _item.type == _type:
                    Master.coins += _item.price
                    print("移除物品：", _item.name)
                    inventory.remove_item(_item)
        EventBus.update_inventory.emit()
        )
    
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        queue_free()
        )

