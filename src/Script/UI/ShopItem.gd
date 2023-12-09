extends Panel

@export var goods:Goods

@onready var icon:TextureRect = %Icon
@onready var title_label:Label = %TitleLabel
@onready var cost_label:Label = %CostLabel
@onready var buy_btn:Button = %BuyBtn


func _ready() -> void:
    buy_btn.pressed.connect(func():
        goods.try_to_buy()
        )
    
    update_ui()


func update_ui() -> void:
    icon.texture = load(Reward.get_reward_icon_path(goods.reward.type))
    title_label.text = goods.name
    cost_label.text = "%s %s" % [str(goods.cost), goods.get_cost_string()]
      
