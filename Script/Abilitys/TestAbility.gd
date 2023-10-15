class_name TestAbility extends Ability

func activate(event: ActivationEvent) -> void:
    super.activate(event) 
    
    if not event.character:
        return
    
    var _fire_ball:CharacterBody2D = Builder.build_a_fireball()
    _fire_ball.global_position = event.character.global_position
    
    _fire_ball.velocity = _fire_ball.global_position.\
    direction_to(event.character.closest_enemy.global_position) * 500.0
    
    Master.world.add_child(_fire_ball)

func can_activate(event: ActivationEvent) -> bool:
    return super.can_activate(event)
