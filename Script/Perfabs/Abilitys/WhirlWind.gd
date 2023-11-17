extends AbilityScene

@onready var timer:Timer = $Timer
@onready var shadow_timer:Timer = $ShadowTimer

func _ready() -> void:
    var _damage_data:CharacterData = CharacterData.new()
    _damage_data.damage = (actor.output_data.weapon_damage * 0.37)
    
    $SimpleHitBoxComponent.damage_data = _damage_data
    
    $SimpleHitBoxComponent.damage = 50
    $AnimationPlayer.play("run")
