extends Panel

@onready var title_bar:MarginContainer = %TitleBar

var cancel_event:Callable = func():
    queue_free()

func _ready() -> void:
    title_bar.cancel_callable = cancel_event
