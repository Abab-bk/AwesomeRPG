extends AbilityScene

func _ready() -> void:
    global_position = actor.global_position
    set_damage(actor.flower_buff_manager.output_data.damage)
    var speed = randf_range(500, 1000)
    
    if actor.closest_enemy:
        $FireBall2.velocity = self.global_position.\
        direction_to(actor.closest_enemy.global_position) * speed
    else:
        $FireBall2.velocity = actor.global_position * speed

func set_damage(_v:float) -> void:
    $FireBall2/SimpleHitBoxComponent.damage = _v
