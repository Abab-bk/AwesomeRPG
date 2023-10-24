extends CharacterBody2D

func _ready() -> void:
    $SimpleHitBoxComponent.disable_target = Master.player
    $SimpleHitBoxComponent.handled_hit.connect(func():queue_free())

func _physics_process(_delta: float) -> void:
    move_and_slide()
