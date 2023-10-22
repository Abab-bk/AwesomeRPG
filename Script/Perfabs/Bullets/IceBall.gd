extends CharacterBody2D

func _ready() -> void:
    $SimpleHitBoxComponent.disable_target = Master.player
    
    velocity = Vector2(500, 1000)
    await get_tree().create_timer(1.0).timeout
    queue_free()

func _physics_process(delta: float) -> void:
    move_and_slide()
