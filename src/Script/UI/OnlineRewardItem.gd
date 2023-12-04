extends Panel

@export var target_time:TimeResource
@export var reward_list:Array[Reward]

@onready var title_label:Label = %TitleLabel
@onready var rewards:HBoxContainer = %Rewards
@onready var check_btn:Button = %CheckBtn

func _ready() -> void:
    check_btn.pressed.connect(func():
        var _current_time:TimeResource = TimeManager.get_current_time_resource() as TimeResource
        if _current_time.is_larger_than_time(target_time):
            get_reward()
        else:
            EventBus.new_tips.emit("时间不到！")
        )
    update_ui()

func update_ui() -> void:
    for i in rewards.get_children():
        i.queue_free()
    
    for i in reward_list:
        rewards.add_child(Builder.build_a_reward_item_ui(i))

func get_reward() -> void:
    for i in reward_list:
        i.get_reward()
