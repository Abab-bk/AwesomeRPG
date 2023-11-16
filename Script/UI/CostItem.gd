extends VBoxContainer

@onready var texture_rect:TextureRect = %TextureRect
@onready var label:Label = %Label

func set_content(text:String, icon_path:String = "res://icon.svg") -> void:
    texture_rect.texture = load(icon_path)
    label.text = text
