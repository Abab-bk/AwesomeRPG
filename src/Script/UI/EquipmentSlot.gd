extends Panel

signal work_ok

@onready var slots_img:TextureRect = $MarginContainer/SlotsImg
@onready var button:Button = $Button
@onready var background:NinePatchRect = $Background

@export var current_equipment_type:Const.EQUIPMENT_TYPE = Const.EQUIPMENT_TYPE.头盔

@export var item:InventoryItem:
    set(v):
        item = v
        if item:
            set_img(item.texture_path)
            $MarginContainer/SlotsImg.modulate = Color("FFFFFF")
        else:
            __set_()
            $MarginContainer/SlotsImg.modulate = Color("636363")
@export var id:String = ""

func _ready() -> void:
    EventBus.equipment_down_ok.connect(func(_type, _item):
        if current_equipment_type == _type:
            item = null
        )
    EventBus.equipment_up_ok.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):         
            if not current_equipment_type == _type:
                return
            
            if item != null:
                # 加入背包原来的装备
                EventBus.add_item.emit(item)
                # 卸下原来的装备：
                EventBus.equipment_down.emit(current_equipment_type, item)
            
            set_item(_item)
            EventBus.change_item_tooltip_state.emit(null)
            EventBus.update_inventory.emit()
            )
    
    #EventBus.save.connect(func():
        #FlowerSaver.set_data("epuipment_slot_%s" % id, item)
        #)
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("flyed_just_now"):
            if FlowerSaver.get_data("flyed_just_now") == true:
                return
        
        if Master.player.compute_data.quipments.has(current_equipment_type):
            if Master.player.compute_data.quipments[current_equipment_type] != null:
                item = Master.player.compute_data.quipments[current_equipment_type]
        
        #item = FlowerSaver.get_data("epuipment_slot_%s" % id)
        update_color()
        )
    
    button.pressed.connect(func():
        EventBus.change_item_tooltip_state.emit(item, true)
        )
    
    __set_()
    

func __set_() -> void:
    match current_equipment_type:
        Const.EQUIPMENT_TYPE.头盔:
            slots_img.texture = load("res://Assets/Texture/Icons/头盔/4.png")
        Const.EQUIPMENT_TYPE.胸甲:
            slots_img.texture = load("res://Assets/Texture/Icons/胸甲/2.png")
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
    update_color()


func set_item(_item:InventoryItem) -> void:
    if _item == null:
        item = _item
        __set_()
        return
    
    item = _item
    
    update_color()
    set_img(item.texture_path)

func update_color() -> void:
    if not item:
        background.texture = load("res://Assets/UI/Texture/ItemBgNull.png")
        return
    
    match item.quality:
        Const.EQUIPMENT_QUALITY.NORMAL:
            background.texture = load("res://Assets/UI/Texture/ItemBgGray.png")
        Const.EQUIPMENT_QUALITY.BLUE:
            background.texture = load("res://Assets/UI/Texture/ItemBgBlue.png")
        Const.EQUIPMENT_QUALITY.YELLOW:
            background.texture = load("res://Assets/UI/Texture/ItemBgGreen.png")
        Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
            background.texture = load("res://Assets/UI/Texture/ItemBgPurple.png")
        Const.EQUIPMENT_QUALITY.GOLD:
            background.texture = load("res://Assets/UI/Texture/ItemBgGold.png")


func set_img(_path:String) -> void:
    slots_img.texture = load(_path)
