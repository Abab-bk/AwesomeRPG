extends Control

@onready var cover:TextureRect = %Cover

@onready var show_result_timer:Timer = $ShowResultTimer

@onready var pull_1_btn:Button = %Pull1Btn
@onready var pull_10_btn:Button = %Pull10Btn
@onready var continue_btn:Button = %ContinueBtn

@onready var rewards_ui:VBoxContainer = %Rewards

@onready var reward_result:MarginContainer = $RewardResult

@onready var animation:ColorRect = $Animation
@onready var blur:ColorRect = $Blur
@onready var animation_player:AnimationPlayer = $RewardResult/AnimationPlayer

@export var gacha_pool:GachaPool

@export var gacha_pool_id:int = 1002

func _ready() -> void:
    gacha_pool = Master.get_gacha_pool_by_id(1002) as GachaPool
    gacha_pool.reward_list.append_array(Master.get_base_gacha_pool().reward_list)
    
    pull_1_btn.pressed.connect(start_gacha.bind(1))
    pull_10_btn.pressed.connect(start_gacha.bind(10))
    
    continue_btn.pressed.connect(func():
        animation_player.play_backwards("show_blur")
        await animation_player.animation_finished
        reward_result.hide()
        animation.hide()
        blur.show()
        
        for i in rewards_ui.get_children():
            i.queue_free()
        )
    
    animation.hide()
    reward_result.hide()
    blur.hide()


func start_gacha(_count:int) -> void:
    if Master.gacha_money < _count:
        EventBus.new_tips.emit("神恩石不足")
        return
    
    animation.show()
    blur.hide()
    show_result_timer.start()
    
    pull_gacha(_count)
    
    SoundManager.play_ui_sound(load(Master.SOUNDS.Myster))
    
    await show_result_timer.timeout
    reward_result.show()
    blur.show()
    animation_player.play("show_blur")
    await animation_player.animation_finished
    animation_player.play("appear")


func pull_gacha(_count:int) -> void:
    for i in _count:
        EventBus.gacha_pull_1.emit()
        Master.gacha_money -= 1
        animation.show()
        
        var _rewerd_weight:Array[Array] = []
        for _reward_item in gacha_pool.reward_list:
            _rewerd_weight.append([_reward_item, _reward_item.weight])
        
        var _chooser:Chooser = Chooser.new(_rewerd_weight)
        var _get_reward:Reward = _chooser.pick() as Reward
        
        if _get_reward.type == Reward.REWARD_TYPE.FRIEND:
            if _get_reward.reward_value in Master.friends_inventory.keys():
                _get_reward = get_memory_reward_by_friend_id(_get_reward.reward_value)
        
        var _desc:String = _get_reward.get_reward(false)
        
        var _new_reward_card = load("res://Scene/UI/GachaCard.tscn").instantiate()
        _new_reward_card.title = _desc
        _new_reward_card.type = _get_reward.type
        rewards_ui.add_child(_new_reward_card)
    
    Master.save_all_invenrory()


func get_memory_reward_by_friend_id(_id:int) -> Reward:
    var _result:Reward = Reward.new()
    _result.type = Reward.REWARD_TYPE.MEMORY
    _result.reward_value = _id
    return _result
