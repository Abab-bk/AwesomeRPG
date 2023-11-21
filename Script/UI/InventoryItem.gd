extends Panel

signal pressed(item:InventoryItem)

@export var item:InventoryItem
@onready var name_label:Label = %NameLabel
@onready var button:Button = $Button

@onready var texture:TextureRect = %Texture
@onready var background:NinePatchRect = $Background

var checked:bool = false
var press_mode:String = ""

func _ready() -> void:
    button.pressed.connect(func():
        if press_mode == "move":
            EventBus.change_item_tooltip_state.emit(item, false, true)
            pressed.emit(item)
            return
        
        if press_mode == "display":
            EventBus.change_item_tooltip_state.emit(item, false, false, false)
        
        EventBus.change_item_tooltip_state.emit(item)
        pressed.emit(item)
        )
    update_ui()

func clean() -> void:
    item = null
    update_ui()

func update_ui() -> void:
    if not item:
        background.texture = load("res://Assets/UI/Texture/ItemBgGray.png")
        texture.texture = null
        name_label.text = ""
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
    
    texture.texture = load(item.texture_path)
    name_label.text = item.name
