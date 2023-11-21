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

@export var checked:bool = false

var target_time:TimeResource = TimeResource.new(0, 0, 0)

func _ready() -> void:
    check_btn.pressed.connect(func():
        if TimeManager.get_current_time_resource().is_larger_than_time(target_time):
            print("签到成功")
            get_reward()
            checked = true
            Master.last_checkin_time = target_time
            check_btn.hide()
            return
        EventBus.new_tips.emit("时间不到，无法签到")
        print("时间不到，无法签到")
        )
    
    EventBus.save.connect(func():
        FlowerSaver.set_data("days_check_%s_time" % str(current_day), target_time)
        FlowerSaver.set_data("days_check_%s_checked" % str(current_day), checked)        
        )
    EventBus.load_save.connect(func():
        target_time = FlowerSaver.get_data("days_check_%s_time" % str(current_day))
        checked = FlowerSaver.get_data("days_check_%s_checked" % str(current_day))
        if checked:
            check_btn.hide()
        )
    
    title_label.text = "第 %s 天" % str(current_day + 1)
    target_time = TimeManager.get_current_time_resource() as TimeResource
    reward_label.text = "x%s" % str(reward_value)
    
    match reward_type:
        REWARD_TYPE.COINS:
            icon.texture = load("res://Assets/UI/Icons/Coins.svg")
    
    for i in current_day:
        target_time = target_time.get_next_day_time()
    
    if checked:
        check_btn.hide()


func get_reward() -> void:
    match reward_type:
        REWARD_TYPE.COINS:
            Master.coins += reward_value
            EventBus.show_popup.emit("签到成功", "获得奖励：%s 金币" % str(reward_value))
