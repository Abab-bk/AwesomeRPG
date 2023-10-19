extends Label

# HACK: 待优化

func _ready() -> void:
    var tween:Tween = create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(0, -100), 0.5)
    await tween.finished
    queue_free()
