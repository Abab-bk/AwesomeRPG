extends Panel

enum REWARD_TYPE {
    COINS,
}

@export var current_day:int
@export var reward_type:REWARD_TYPE
@export var reward_value:int

@onready var title_label:Label = %TitleLabel
@onready var reward_label:Label = %RewardLabel
@onready var check_btn:Button = %CheckBtn

@onready var icon:TextureRect = %Icon

var target_time:TimeResource = TimeResource.new(0, 0, 0)

func _ready() -> void:
    check_btn.pressed.connect(func():
        if Master.last_checkin_time.is_larger_than_time(target_time):
            print("签到成功")
            get_reward()
            Master.last_checkin_time = target_time
            check_btn.hide()
            return
        print("时间不到，无法签到")
        )
    
    title_label.text = "第 %s 天" % str(current_day + 1)
    target_time = TimeManager.get_current_time_resource() as TimeResource
    reward_label.text = "x%s" % str(reward_value)
    
    match reward_type:
        REWARD_TYPE.COINS:
            icon.texture = load("res://Assets/UI/Icons/Coins.svg")
    
    for i in current_day:
        target_time = target_time.get_next_day_time()


func get_reward() -> void:
    match reward_type:
        REWARD_TYPE.COINS:
            Master.coins += reward_value
            EventBus.show_popup.emit("签到成功", "获得奖励：%s 金币" % str(reward_value))
