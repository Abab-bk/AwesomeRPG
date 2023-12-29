extends AbilityScene

@onready var timer:Timer = $Timer
@onready var shadow_timer:Timer = $ShadowTimer

func _ready() -> void:
    var _damage_data:CharacterData = CharacterData.new()
    _damage_data.damage = max((actor.output_data.damage * 0.37), 10)
    
    $SimpleHitBoxComponent.damage_data = _damage_data
    
    $SimpleHitBoxComponent.damage = _damage_data.damage
    $AnimationPlayer.play("run")
