extends AbilityScene

var temp:float

func _ready() -> void:
    temp = actor.compute_data.speed
    actor.compute_data.speed += 200
    actor.compute()

func timeout() -> void:
    actor.compute_data.speed = temp
    actor.compute()
    super()
