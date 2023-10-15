extends CharacterBody2D

func _ready() -> void:
    $HitBoxComponent.disable_target = Master.player
    $HitBoxComponent.handled_hit.connect(func():queue_free())

func set_damage(_v:int) -> void:
    $HitBoxComponent.damage = _v

func _physics_process(_delta: float) -> void:
    move_and_slide()
