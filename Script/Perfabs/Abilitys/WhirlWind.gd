extends AbilityScene

@onready var timer:Timer = $Timer
@onready var shadow_timer:Timer = $ShadowTimer

func _ready() -> void:
#    shadow_timer.timeout.connect(func():
#        var _new_trail:Sprite2D = Builder.build_a_trail()
##        move_child(_new_trail, get_index())
#        _new_trail.texture = $Sprite2D.texture
#        _new_trail.global_position = $Sprite2D.global_position
#        _new_trail.rotation = $Sprite2D.rotation
#        add_child(_new_trail)        
#        )
    
#    shadow_timer.start()
    $Sprite2D/SimpleHitBoxComponent.damage = 50
    $AnimationPlayer.play("run")
