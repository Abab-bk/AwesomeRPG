extends Panel

@onready var icon:TextureRect = %Icon
@onready var enter_btn:Button = %EnterBtn

@onready var name_label:Label = %NameLabel
@onready var cost_label:Label = %CostLabel
@onready var reward_label:Label = %RewardLabel

@export var show_info_panel:Panel
@export var data:DungeonData


func _ready() -> void:
    if not data:
        return
    name_label.text = data.name
    cost_label.text = "门票钱：%s" % str(data.need_cost)
    reward_label.text = "奖励：%s" % Reward.get_string(data.reward_type)
    
    icon.texture = load(data.icon_path)
    
    enter_btn.pressed.connect(func():
        show_info_panel.show_dungeon(data)
        )
