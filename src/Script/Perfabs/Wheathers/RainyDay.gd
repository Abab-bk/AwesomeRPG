extends WheatherScene

func _ready() -> void:
    Master.player.flower_buff_manager.compute_data.speed -= 200

func disappear() -> void:
    Master.player.flower_buff_manager.compute_data.speed += 200
    queue_free()
