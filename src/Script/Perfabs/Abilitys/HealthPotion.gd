extends AbilityScene

func _ready() -> void:
    actor.output_data.hp += (actor.output_data.max_hp * 0.5)

func timeout() -> void:
    super()
