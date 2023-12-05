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
        "moneys[white]":
            icon.texture = load("res://Assets/UI/Icons/MoneyWhite.png")
        "moneys[blue]":
            icon.texture = load("res://Assets/UI/Icons/MoneyRed.png")
        "moneys[purple]":
            icon.texture = load("res://Assets/UI/Icons/MoneyPurple.png")
        "moneys[yellow]":
            icon.texture = load("res://Assets/UI/Icons/MoneyYellow.png")


func update_ui() -> void:
    match target:
        "moneys[white]":
            coins_label.text = str(Master.moneys.white)
            return
        "moneys[blue]":
            coins_label.text = str(Master.moneys.blue)
            return
        "moneys[purple]":
            coins_label.text = str(Master.moneys.purple)
            return
        "moneys[yellow]":
            coins_label.text = str(Master.moneys.yellow)            
            return
    
    coins_label.text = str(Master[target])
