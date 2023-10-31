extends Control

@onready var cloth_items:VBoxContainer = %ClothItems

var toggle_button := preload("res://Scene/UI/ToggleButton.tscn")

func _ready() -> void:
    var dir:DirAccess = DirAccess.open("res://Assets/Characters/PlayerAssets/")
    
    var i:int = -1
    for _toggle_btn in cloth_items.get_children():
        i += 1
        var names:Array = dir.get_directories()
        _toggle_btn.signals = names[i]
        _toggle_btn.changed.connect(func():
            %AnimationPlayer.play("scml/Idle")
            )
        
