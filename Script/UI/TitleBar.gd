extends VBoxContainer

@export var title_text:String = "默认"

func _ready() -> void:
    %TitleLabel.text = title_text
