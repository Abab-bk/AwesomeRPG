extends Node2D

func _ready() -> void:
    var _tw:Tween = create_tween()
    _tw.tween_property(%Coin1, "position", Vector2(80, -24), 0.4)
    _tw.tween_property(%Coin2, "position", Vector2(-71, -26), 0.4)
    _tw.tween_property(%Coin3, "position", Vector2(-22, -27), 0.4)

    SoundManager.play_sound(load(Const.SOUNDS.CollectCoin))

    await _tw.finished
    queue_free()