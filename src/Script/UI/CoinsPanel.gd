extends HBoxContainer

@onready var coins_label:Label = %CoinsLabel
@onready var icon:TextureRect = %Icon

@export var target:String = ""

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)
    EventBus.coins_changed.connect(update_ui)
    
    match target:
        "coins":
            icon.texture = load(Reward.get_reward_icon_path(Reward.REWARD_TYPE.COINS))
        "gacha_money":
            icon.texture = load(Reward.get_reward_icon_path(Reward.REWARD_TYPE.GACHA_MONEY))
        "gacha_money_part":
            icon.texture = load(Reward.get_reward_icon_path(Reward.REWARD_TYPE.GACHA_MONEY_PART))


func update_ui() -> void:
    coins_label.text = str(Master[target])
