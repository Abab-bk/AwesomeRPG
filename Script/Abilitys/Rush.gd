extends FlowerAbility

var temp

func active() -> void:
    super()
    var _rush_vfx = load("res://Scene/Perfabs/Abilitys/Rush.tscn").instantiate()
    _rush_vfx.actor = actor    
    
    actor.add_child(_rush_vfx)
    
    un_active()

