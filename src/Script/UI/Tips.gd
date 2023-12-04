extends Control

@onready var label:Label = %Label

var text:String = ""

func _ready() -> void:
    label.text = text
    $AnimationPlayer.play("run")
    await $AnimationPlayer.animation_finished
    queue_free()
