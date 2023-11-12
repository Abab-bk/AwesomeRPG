extends AbilityScene

func _ready() -> void:
    global_position = actor.global_position
    
    var _damage_data:CharacterData = CharacterData.new()
    _damage_data.damage = (actor.output_data.weapon_damage * 2.4) * 0.8
    
    $FireBall2/SimpleHitBoxComponent.set_damage_data(_damage_data)
    
    var speed = randf_range(500, 1000)
    
    if actor.closest_enemy:
        $FireBall2.velocity = self.global_position.\
        direction_to(actor.closest_enemy.global_position) * speed
    else:
        $FireBall2.velocity = actor.global_position * speed
