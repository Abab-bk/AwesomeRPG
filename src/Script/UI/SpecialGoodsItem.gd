extends Panel

@export var goods:Goods

@onready var button:Button = $Button
@onready var texture_rect:TextureRect = $TextureRect

var try_to_buy_state:bool = false

func _ready() -> void:    
    PockAd.get_reward.connect(func():
        if not try_to_buy_state:
            return
        Master.buyed_prime_access_today = true
        goods.reward.get_reward()
        update_ui())

    button.pressed.connect(func():
        EventBus.show_popup.emit("购买", "确定购买吗？需要观看一个广告", true, func():
            try_to_buy_state = true
            PockAd.show_reward_video_ad()
        , func():pass))
        
    update_ui()


func update_ui() -> void:
    if Master.buyed_prime_access_today:
        texture_rect.texture = load("res://Assets/UI/Texture/PrimeAccessSoldOutCover.png")
        button.disabled = true
    else:
        texture_rect.texture = load("res://Assets/UI/Texture/PrimeAccessCover.png")
        button.disabled = false
        
