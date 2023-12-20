extends WheatherScene

var _temp:float = 0.0


func _ready() -> void:
    _temp = Master.player.flower_buff_manager.compute_data.fire_damage * 0.5
    Master.player.flower_buff_manager.compute_data.fire_damage -= _temp


func disappear() -> void:
    Master.player.flower_buff_manager.compute_data.fire_damage += _temp
    queue_free()
