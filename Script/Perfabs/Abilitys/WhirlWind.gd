extends AbilityScene

@onready var timer:Timer = $Timer
@onready var shadow_timer:Timer = $ShadowTimer

func _ready() -> void:
    $SimpleHitBoxComponent.damage = 50
    $AnimationPlayer.play("run")
