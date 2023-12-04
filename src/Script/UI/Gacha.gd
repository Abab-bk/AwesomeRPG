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
        animation.show()
        var _get_reward:Reward = gacha_pool.reward_list.pick_random() as Reward
        var _desc:String = _get_reward.get_reward(false)
        
        var _new_reward_card = load("res://Scene/UI/GachaCard.tscn").instantiate()
        _new_reward_card.title = _desc
        rewards_ui.add_child(_new_reward_card)
    
    # animation.hide()
