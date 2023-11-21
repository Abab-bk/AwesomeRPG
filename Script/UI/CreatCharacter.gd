extends Control

signal creat_ok

@onready var yes_btn:Button = %YesBtn
@onready var line_edit:LineEdit = %LineEdit

var cancel_event:Callable = func():
    hide()

func _ready() -> void:
    %TitleBar.cancel_callable = cancel_event
    
    yes_btn.pressed.connect(func():
        if line_edit.text == "":
            return
        
        Master.player_name = line_edit.text
        creat_ok.emit()
        )
