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
    # TODO: 增加 reward 文本
    match data.reward_type:
        "Coins":
            reward_label.text = "奖励：%s 金币" % str(data.reward_value)
        "MoneyWhite":
            reward_label.text = "奖励：%s 奉献之灰" % str(data.reward_value)            
        "MoneyBlue":
            reward_label.text = "奖励：%s 天堂之灰" % str(data.reward_value)
        "MoneyPurple":
            reward_label.text = "奖励：%s 赦罪之血" % str(data.reward_value)
        "MoneyYellow":
            reward_label.text = "奖励：%s 天使之泪" % str(data.reward_value)
        "Function":
            reward_label.text = "奖励：%s 新功能" % str(data.reward_value)            
    icon.texture = load(data.icon_path)
    
    enter_btn.pressed.connect(func():
        show_info_panel.show_dungeon(data)
        )
