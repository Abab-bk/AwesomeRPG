extends TextureButton

var _get_reward_state:bool = false

func _ready() -> void:
    global_position = Vector2(0, 0)
    show()
    move()

    pressed.connect(func():
        EventBus.show_popup.emit("神秘奖励", "要观看广告获得神秘奖励吗?", true,
        func():
            _get_reward_state = true
            PockAd.show_reward_video_ad(),
        func():
            hide()
        )
        )

    PockAd.get_reward.connect(func():
        if not _get_reward_state:
            return
        
        var _reward:GachaPool = Master.get_base_gacha_pool()
        _reward.reward_list.pick_random().get_reward()
        _get_reward_state = false
        )

func move() -> void:
    if Master.today_watch_ad_count >= Const.MAX_AD_COUNT:
        return
    
    var _tw:Tween = create_tween()
    _tw.tween_property(self, "global_position", Vector2(1103, 1410), 10.0)
    await _tw.finished
    hide()
    global_position = Vector2(0, 0)
    await get_tree().create_timer(60.0).timeout
    move()
