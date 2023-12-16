extends Control

@onready var yes_btn:Button = %YesBtn
@onready var reward_item_ui:Panel = %RewardItemUI


func _ready() -> void:
    yes_btn.pressed.connect(pull)


func pull() -> void:
    yes_btn.disabled = true

    var _reward_pool:GachaPool = Master.get_base_gacha_pool()
    
    var _chooser:Chooser = Chooser.new()
    
    for _reward_item:Reward in _reward_pool.reward_list:
         _chooser.add_item(_reward_item, _reward_item.weight)
    
    var _result_reward:Reward

    for _count:int in 50:
        var _reward:Reward = _chooser.pick()
        _result_reward = _reward
        reward_item_ui.update_ui(_reward)
        SoundManager.play_sound(load(Master.SOUNDS.Forge))
        await get_tree().create_timer(0.1).timeout

    #SoundManager.play_ui_sound(load(Master.POPUP_SOUNDS))
    EventBus.set_should_show_reward_day_reward.emit(false)
    _result_reward.get_reward()
    queue_free()
