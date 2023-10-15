class_name VisiableQueueFreeComponent extends VisibleOnScreenNotifier2D

@export var actor:Node2D

func _ready() -> void:
    screen_exited.connect(func():
        if actor:
            actor.queue_free())
