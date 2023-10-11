extends Panel

@export var item:InventoryItem
@onready var texture:TextureRect = %Texture
@onready var name_label:Label = %NameLabel
@onready var button:Button = $Button

func _ready() -> void:
    button.pressed.connect(func():
        if not item:
            return
        EventBus.show_item_tooltip.emit(item, get_global_mouse_position()
    ))

func update_ui() -> void:
    texture.texture = load(item.texture_path)
    name_label.text = item.name
