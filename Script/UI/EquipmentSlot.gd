extends Panel

signal work_ok

@onready var slots_img:TextureRect = $MarginContainer/SlotsImg
@onready var button:Button = $Button

@export var current_equipment_type:Const.EQUIPMENT_TYPE = Const.EQUIPMENT_TYPE.头盔

var item:InventoryItem:
    set(v):
        item = v
        if item:
            $MarginContainer/SlotsImg.modulate = Color("FFFFFF")
        else:
            $MarginContainer/SlotsImg.modulate = Color("636363")

func _ready() -> void:
    EventBus.equipment_down.connect(func(_xx, _xxx):set_item(null))
    
    button.pressed.connect(func():
        EventBus.change_item_tooltip_state.emit(item, true)
        )
    
    __set_()

func __set_() -> void:
    match current_equipment_type:
        Const.EQUIPMENT_TYPE.头盔:
            slots_img.texture = load("res://Assets/Texture/Icons/头盔/3.png")
        Const.EQUIPMENT_TYPE.胸甲:
            slots_img.texture = load("res://Assets/Texture/Icons/胸甲/1.png")
        Const.EQUIPMENT_TYPE.手套:
            slots_img.texture = load("res://Assets/Texture/Icons/手套/7.png")
        Const.EQUIPMENT_TYPE.靴子:
            slots_img.texture = load("res://Assets/Texture/Icons/靴子/1.png")
        Const.EQUIPMENT_TYPE.皮带:
            slots_img.texture = load("res://Assets/Texture/Icons/皮带/1.png")
        Const.EQUIPMENT_TYPE.裤子:
            slots_img.texture = load("res://Assets/Texture/Icons/裤子/1.png")
        Const.EQUIPMENT_TYPE.护身符:
            slots_img.texture = load("res://Assets/Texture/Icons/护身符/25.png")
        Const.EQUIPMENT_TYPE.戒指:
            slots_img.texture = load("res://Assets/Texture/Icons/戒指/1.png")
        Const.EQUIPMENT_TYPE.武器:
            slots_img.texture = load("res://Assets/Texture/Icons/Sword/Sword1.png")

func set_item(_item:InventoryItem) -> void:
    if _item == null:
        item = _item
        __set_()
        return
    
    item = _item
    set_img(item.texture_path)

func set_img(_path:String) -> void:
    slots_img.texture = load(_path)
