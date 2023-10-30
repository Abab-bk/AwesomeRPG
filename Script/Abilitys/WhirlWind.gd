extends FlowerAbility

func active() -> void:
    super()
    
    var _sword:Node2D = load("res://Scene/Perfabs/Abilitys/WhirlWind.tscn").instantiate()
    Master.player.add_child(_sword)
    
    un_active()
