extends MarginContainer

@export var forged_panel:Control

@onready var yes_btn:Button = %AYesBtn
@onready var cancel_btn:Button = %ACancelBtn

func _ready() -> void:
    cancel_btn.pressed.connect(func():hide())
    yes_btn.pressed.connect(func():
        forged_panel.accept_forged()
        hide()
        )
