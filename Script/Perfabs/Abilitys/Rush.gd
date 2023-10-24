extends AbilityScene

var temp

func _ready() -> void:
    temp = actor.data.speed
    actor.data.speed += 200

func timeout() -> void:
    actor.data.speed = temp
    super()
