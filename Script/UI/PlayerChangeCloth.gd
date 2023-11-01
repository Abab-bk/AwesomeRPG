extends Control

@onready var cloth_items:VBoxContainer = %ClothItems

var toggle_button := preload("res://Scene/UI/ToggleButton.tscn")

func _ready() -> void:
    for _toggle_btn in cloth_items.get_children():
        _toggle_btn.changed.connect(func():
            %AnimationPlayer.play("scml/Idle")
            )
        
