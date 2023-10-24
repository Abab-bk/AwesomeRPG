extends AbilityScene

var ice_ball := load("res://Scene/Perfabs/Bullets/IceBall.tscn")

func _ready() -> void:
    $Timer.timeout.connect(func():
        var _new_ball:CharacterBody2D = ice_ball.instantiate()
        _new_ball.global_position = Vector2(randi_range(0, $Sprite2D.texture.get_width() * $Sprite2D.scale.x), randi_range(0, $Sprite2D.texture.get_height()))
        call_deferred("add_child", _new_ball)
        )

