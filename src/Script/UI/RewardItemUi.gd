extends Panel

@onready var icon:TextureRect = %Icon
@onready var reward_label:Label = %RewardLabel

func update_ui(_reward:Reward) -> void:
    icon.texture = load(Reward.get_reward_icon_path(_reward.type))
    reward_label.text = str(_reward.reward_value)
