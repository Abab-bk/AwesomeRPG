class_name FireBall extends FlowerAbility

var speed:float = 800.0

func active() -> void:
    super()
    var _fire_ball:CharacterBody2D = Builder.build_a_fireball()
    _fire_ball.global_position = actor.global_position
    # 设置伤害
    _fire_ball.set_damage(50)
    
    speed = randf_range(500, 1000)
    
    if actor.closest_enemy and _fire_ball:
        _fire_ball.velocity = _fire_ball.global_position.\
        direction_to(actor.closest_enemy.global_position) * speed
    else:
        _fire_ball.velocity = actor.global_position * speed
    
    Master.world.add_child(_fire_ball)
