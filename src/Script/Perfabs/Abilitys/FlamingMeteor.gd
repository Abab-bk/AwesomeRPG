extends AbilityScene

var fire_ball := load("res://Scene/Perfabs/Bullets/FlamingMeteorBullet.tscn")

func _ready() -> void:
    global_position = actor.global_position
    
    $Timer.timeout.connect(func():
        var _new_ball:CharacterBody2D = fire_ball.instantiate()
        _new_ball.global_position = Vector2(randi_range(0, $Sprite2D.texture.get_width() * $Sprite2D.scale.x), randi_range(0, $Sprite2D.texture.get_height()))
        _new_ball.set_damage(actor.output_data.fire_damage * 0.1)
        call_deferred("add_child", _new_ball)
        )
