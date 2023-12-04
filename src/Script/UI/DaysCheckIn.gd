extends Control

@onready var title_bar:MarginContainer = %TitleBar
@onready var items:VBoxContainer = %Items

func _ready() -> void:
    var _count:int = 1001
    
    for i in items.get_children():
        i.reward_list = Master.get_days_reward_list_by_id(_count)
        i.update_ui()
        _count += 1
