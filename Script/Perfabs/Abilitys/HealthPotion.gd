extends AbilityScene

func _ready() -> void:
    actor.output_data.hp += 300

func timeout() -> void:
    super()
