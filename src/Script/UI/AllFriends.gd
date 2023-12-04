extends GridContainer


func _ready() -> void:
    visibility_changed.connect(func():
        if not visible:
            clear_ui()
        )
    clear_ui()


func update_ui() -> void:
    pass


func clear_ui() -> void:
    for i in get_children():
        i.queue_free()
