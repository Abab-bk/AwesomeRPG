extends AbilityScene

var temp:float

func _ready() -> void:
    temp = actor.data.speed
    actor.data.speed += 200

func timeout() -> void:
    actor.data.speed = temp
    super()
