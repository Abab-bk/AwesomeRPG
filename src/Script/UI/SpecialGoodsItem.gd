extends Panel

@export var goods:Goods

@onready var button:Button = $Button
@onready var texture_rect:TextureRect = $TextureRect


func _ready() -> void:
    goods.buyed.connect(func():
        Master.buyed_prime_access_today = true
        update_ui()
        )
    button.pressed.connect(goods.try_to_buy)
    update_ui()


func update_ui() -> void:
    if Master.buyed_prime_access_today:
        texture_rect.texture = load("res://Assets/UI/Texture/PrimeAccessSoldOutCover.png")
        button.disabled = true
    else:
        texture_rect.texture = load("res://Assets/UI/Texture/PrimeAccessCover.png")
        button.disabled = false
        
