class_name FireBall extends FlowerAbility

func active() -> void:
    super()
    
    var _fire_ball:CharacterBody2D = Builder.build_a_fireball()
    _fire_ball.global_position = actor.global_position
    
    _fire_ball.velocity = _fire_ball.global_position.\
    direction_to(actor.closest_enemy.global_position) * 500.0
    
    Master.world.add_child(_fire_ball)
    
    un_active()
