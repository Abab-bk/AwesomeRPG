extends Panel

@export var item:InventoryItem
@onready var texture:TextureRect = %Texture
@onready var name_label:Label = %NameLabel

func update_ui() -> void:
    texture.texture = load(item.texture_path)
    name_label.text = item.name
