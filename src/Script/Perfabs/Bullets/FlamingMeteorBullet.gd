extends CharacterBody2D

func _ready() -> void:
    $SimpleHitBoxComponent.disable_target = Master.player
    
    velocity = Vector2(500, 1000)
    await get_tree().create_timer(1.0).timeout
    queue_free()

func set_damage(value:float) -> void:
    $SimpleHitBoxComponent.damage = value

func _physics_process(_delta: float) -> void:
    move_and_slide()
