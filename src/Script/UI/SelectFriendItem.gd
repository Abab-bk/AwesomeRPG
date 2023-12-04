extends Panel

signal selected(_data:FriendData)

@export var data:FriendData:
    set(v):
        data = v
        update_ui()

@onready var icon:TextureRect = %Icon
@onready var name_label:Label = %NameLabel
@onready var rate_label:Label = %RateLabel
@onready var yes_btn:Button = %YesBtn

func _ready() -> void:
    yes_btn.pressed.connect(func():
        selected.emit(data)
        )

func update_ui() -> void:
    if not data:
        name_label.text = "暂无"
        rate_label.text = ""
        icon.texture = load("res://icon.svg")
        return
    
    name_label.text = data.name
    rate_label.text = Const.FRIEND_QUALITY.keys()[data.quality]
    icon.texture = load(data.icon_path)
