extends Panel

@export var current_day:int
@export var reward_list:Array[Reward] = []

@onready var rewards:HBoxContainer = %Rewards

@onready var title_label:Label = %TitleLabel
@onready var check_btn:Button = %CheckBtn

@export var checked:bool = false:
    set(v):
        checked = v
        FlowerSaver.set_data("days_check_%s_checked" % str(current_day), checked)

var target_time:TimeResource = TimeResource.new(0, 0, 0):
    set(v):
        target_time = v
        FlowerSaver.set_data("days_check_%s_time" % str(current_day), target_time)

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
    
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("flyed_just_now"):
            if FlowerSaver.get_data("flyed_just_now") == true:
                return
        target_time = FlowerSaver.get_data("days_check_%s_time" % str(current_day))
        checked = FlowerSaver.get_data("days_check_%s_checked" % str(current_day))
        if checked:
            check_btn.hide()
        )
    
    title_label.text = "第 %s 天" % str(current_day + 1)
    target_time = TimeManager.get_current_time_resource() as TimeResource
    
    for i in current_day:
        target_time = target_time.get_next_day_time()
    
    if checked:
        check_btn.hide()

func update_ui() -> void:
    for i in rewards.get_children():
        i.queue_free()
    
    for i in reward_list:
        var _n = Builder.build_a_reward_item_ui(i)
        rewards.add_child(_n)
        _n.update_ui(i)


func get_reward() -> void:
    for i in reward_list:
        i.get_reward(true)
    #EventBus.show_popup.emit("签到成功", "获得奖励：%s %s" % str(reward.reward_value, Reward.get_string(reward.type)))
