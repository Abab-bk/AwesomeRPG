extends AbilityScene

var temp:float

func _ready() -> void:
    temp = actor.compute_data.speed
    Master.player_camera.zoom = Vector2(0.4, 0.4)
    actor.compute_data.speed += 400
    actor.compute()

func timeout() -> void:
    actor.compute_data.speed = temp
    Master.player_camera.zoom = Vector2(0.5, 0.5)
    actor.compute()
    super()
