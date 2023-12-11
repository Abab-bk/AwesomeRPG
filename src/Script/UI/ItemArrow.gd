extends Panel

signal pressed

@onready var icon:TextureRect = %Icon
@onready var count_label:Label = %CountLabel
@onready var button:Button = $Button

@export var id:int = 0

var icon_path:String = ""
var desc:String = ""

func _ready() -> void:
    icon.texture = load(icon_path)
    count_label.text = desc
    button.pressed.connect(func(): pressed.emit())
