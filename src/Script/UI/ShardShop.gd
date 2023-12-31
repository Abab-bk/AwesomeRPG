extends Control


@onready var contents:GridContainer = %Contents
@onready var special_goods:VBoxContainer = %SpecialGoods


func _ready() -> void:
    pass


func update_ui() -> void:
    for i in contents.get_children():
        i.queue_free()
    for i in special_goods.get_children():
        i.queue_free()

    for i in Master.shops:
        var _goods_info:Goods = Master.get_goods_by_info(i) as Goods
        
        if _goods_info.cost_type == Const.MONEY_TYPE.AD:
            var _shop_item:Panel = load("res://Scene/UI/SpecialGoodsItem.tscn").instantiate()            
            _shop_item.goods = _goods_info
            special_goods.add_child(_shop_item)
        else:
            var _shop_item:Panel = load("res://Scene/UI/ShopItem.tscn").instantiate()            
            _shop_item.goods = _goods_info
            contents.add_child(_shop_item)
    
