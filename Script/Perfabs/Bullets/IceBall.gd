extends CharacterBody2D

func _ready() -> void:
    $SimpleHitBoxComponent.disable_target = Master.player

func set_damage(value:float) -> void:
    $SimpleHitBoxComponent.damage = value

func _physics_process(_delta: float) -> void:
    move_and_slide()

func auto_to_queue_free(_time:float) -> void:
    await get_tree().create_timer(_time).timeout
    queue_free()
