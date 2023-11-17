extends HBoxContainer

@onready var title_label:Label = $TitleLabel
@onready var origin_label:Label = $HBoxContainer/OriginLabel
@onready var new_label:Label = $HBoxContainer/NewLabel

var title:String
var data:Array

func _ready() -> void:
    title_label.text = title
    origin_label.text = str(data[0])
    new_label.text = str(data[1])
