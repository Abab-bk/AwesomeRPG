extends Label

var crit:bool = false
var duration:float = 1.0
var travel:Vector2 = Vector2(0, -300)
var spread:float = PI / 2

func _ready() -> void:
    var _damage:float = float(text)
    
    var movement = travel.rotated(randf_range(-spread / 2, spread / 2))

    var tween:Tween = create_tween()
    
    tween.tween_property(self, "global_position", global_position + movement, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
    
    if crit:
        modulate = Color(1, 0, 0)
        tween.tween_property(self, "scale", scale * 2, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
    
    await tween.finished
    queue_free()
