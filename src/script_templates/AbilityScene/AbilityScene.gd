extends AbilityScene

func _ready() -> void:
    pass

func timeout() -> void:
    # 会自动queue_free()
    super()
