extends Panel

@onready var icon:TextureRect = %Icon
@onready var enter_btn:Button = %EnterBtn
@onready var name_label:Label = %NameLabel

var data:DungeonData

func _ready() -> void:
    if not data:
        return
    name_label.text = data.name
