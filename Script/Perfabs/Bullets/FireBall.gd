extends CharacterBody2D

func _ready() -> void:
    $SimpleHitBoxComponent.disable_target = Master.player
    $SimpleHitBoxComponent.handled_hit.connect(func():queue_free())

func set_damage(_v:float) -> void:
    $SimpleHitBoxComponent.damage = _v

func _physics_process(_delta: float) -> void:
    move_and_slide()
