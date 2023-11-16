extends MarginContainer

@export var title_text:String = "默认"
@export var cancel_callable:Callable = func():pass

func _ready() -> void:
    %CancelBtn.pressed.connect(func():
        cancel_callable.call()
        )
    %TitleLabel.text = title_text
