extends Panel

signal pressed(item:InventoryItem)

@export var item:InventoryItem
@onready var texture:TextureRect = %Texture
@onready var name_label:Label = %NameLabel
@onready var button:Button = $Button

var checked:bool = false

func _ready() -> void:
    button.pressed.connect(func():
        EventBus.change_item_tooltip_state.emit(item)
        pressed.emit(item)
        )

func clean() -> void:
    EventBus.remove_item.emit(item)
    item = null
    update_ui()

func update_ui() -> void:
    if not item:
        texture.texture = null
        name_label.text = ""
        return
    
    texture.texture = load(item.texture_path)
    name_label.text = item.name
