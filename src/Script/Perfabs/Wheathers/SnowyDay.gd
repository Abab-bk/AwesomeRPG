extends WheatherScene

@onready var timer:Timer = $Timer
@onready var timer_2:Timer = $Timer2

func _ready() -> void:
    EventBus.player_dead.connect(func():
        timer.stop()
        timer_2.stop()
        queue_free()
        )
    
    timer.timeout.connect(func():
        var _select:bool = [true, false].pick_random()
        
        #Tracer.info("雪天是否冻结：%s" % str(_select))
        
        if _select:
            if Master.player.current_state == Player.STATE.DEAD:
                return
            Master.player.current_state = Player.STATE.FREEZEING
            
            var _tween:Tween = get_tree().create_tween().bind_node(Master.player)
            _tween.tween_property(Master.player, "modulate", Color.CORNFLOWER_BLUE, 0.1)
            
            timer_2.start()
            return
        
        timer_2.start()
        )
    timer_2.timeout.connect(func():
        var _tween:Tween = get_tree().create_tween().bind_node(Master.player)
        _tween.tween_property(Master.player, "modulate", Color.WHITE, 0.1)
        
        if Master.player.current_state == Player.STATE.DEAD:
            return
        
        Master.player.current_state = Player.STATE.IDLE
        timer.start()
        )
    
    timer_2.one_shot = true    
    timer.one_shot = true
    timer.start()
