extends AbilityScene

var ice_ball := load("res://Scene/Perfabs/Bullets/IceBall.tscn")

func _ready() -> void:
    global_position = actor.global_position / 2
    
    $Timer.timeout.connect(func():
        var _new_ball:CharacterBody2D = ice_ball.instantiate()
        _new_ball.global_position = Vector2(randi_range(0, $Sprite2D.texture.get_width() * $Sprite2D.scale.x), randi_range(0, $Sprite2D.texture.get_height()))
        
        var _new_data:CharacterData = CharacterData.new()
        _new_data.frost_damage = actor.output_data.frost_damage * 0.1
        _new_ball.set_damage_data(_new_data)
        
        call_deferred("add_child", _new_ball)
        _new_ball.velocity = Vector2(500, 1000)
        _new_ball.auto_to_queue_free(2.0)
        )

