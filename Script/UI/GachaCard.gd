extends Control

@onready var icon:TextureRect = %Icon
@onready var title_label:Label = %TitleLabel
@onready var animation_player:AnimationPlayer = %AnimationPlayer

var title:String = ""


func _ready() -> void:
    title_label.text = title
