extends Control

@onready var label:Label = %Label

var text:String = ""

func _ready() -> void:
    
    label.text = text
    await get_tree().create_timer(2.0).timeout
    queue_free()
