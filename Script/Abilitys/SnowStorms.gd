extends FlowerAbility

func active() -> void:
    super()
    
    var _strom:Node2D = load("res://Scene/Perfabs/Bullets/SnowStorms.tscn").instantiate()
    _strom.global_position = actor.global_position + Vector2(-800, 0)
    Master.world.add_child(_strom)
    
    un_active()

