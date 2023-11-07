extends AbilityScene

var ice_ball := load("res://Scene/Perfabs/Bullets/IceBall.tscn")

func _ready() -> void:
    var _new_ball = ice_ball.instantiate() as CharacterBody2D
    _new_ball.velocity = actor.velocity + Vector2(200, 200)
    _new_ball.set_damage()
    
