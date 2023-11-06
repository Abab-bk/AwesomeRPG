extends VBoxContainer

func set_content(text:String, icon_path:String = "res://icon.svg") -> void:
    $TextureRect.texture = load(icon_path)
    $Label.text = text
