extends Panel

@export var item:InventoryItem
@onready var texture:TextureRect = %Texture
@onready var name_label:Label = %NameLabel
@onready var button:Button = $Button

var checked:bool = false

func _ready() -> void:
    button.pressed.connect(func():
        EventBus.change_item_tooltip_state.emit(item)
        )

func update_ui() -> void:
    if not item:
        texture.texture = null
        name_label.text = ""
        return
    
    texture.texture = load(item.texture_path)
    name_label.text = item.name
