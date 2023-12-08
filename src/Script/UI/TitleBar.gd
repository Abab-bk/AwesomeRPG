extends MarginContainer

@export var title_text:String = "默认"
@export var cancel_callable:Callable
@export var show_cancel_btn:bool = true

func _ready() -> void:
    if not show_cancel_btn:
        $CancelBtn.hide()
    
    %CancelBtn.pressed.connect(func():
        if not cancel_callable:
            SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
            owner.owner.change_page(owner.owner.PAGE.HOME)
            return
        
        cancel_callable.call()
        )
    %TitleLabel.text = title_text
