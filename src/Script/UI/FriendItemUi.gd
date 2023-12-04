extends Panel

signal show_friend_panel

@onready var button:Button = $Button

@onready var icon:TextureRect = %Icon
@onready var title_label:Label = %TitleLabel
@onready var rare_label:Label = %RareLabel

func _ready() -> void:
    button.pressed.connect(func():
        
        )
