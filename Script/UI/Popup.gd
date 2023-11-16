extends Panel

signal closed

@onready var title_label:Label = %TitleLabel
@onready var desc_label:RichTextLabel = %DescLabel
@onready var yes_btn:Button = %YesBtn
@onready var cancel_btn:Button = %CancelBtn

var title:String = ""
var desc:String = ""
var show_cancel_btn:bool = false

var yes_event:Callable = func():pass
var cancel_event:Callable = func():pass

func _ready() -> void:
    title_label.text = title
    desc_label.text = "[center]%s[/center]" % desc
    
    yes_btn.pressed.connect(func():
        yes_event.call()
        queue_free()
        )
    cancel_btn.pressed.connect(func():
        closed.emit()
        cancel_event.call()
        queue_free()
        )

    if not show_cancel_btn:
        cancel_btn.hide()
