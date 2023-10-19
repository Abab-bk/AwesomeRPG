extends Node2D

func set_texture(v) -> void:
    $Sprite2D.texture = v

func _ready() -> void:
    var tween:Tween = get_tree().create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(188, -94), 0.2)
    tween.tween_property(self, "global_position", global_position + Vector2(366, 0), 0.2)
    await tween.finished
    queue_free()
    
