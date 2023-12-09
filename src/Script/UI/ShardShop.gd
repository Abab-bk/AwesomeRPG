extends Control


@onready var contents:GridContainer = %Contents


func _ready() -> void:
    pass


func update_ui() -> void:
    for i in contents.get_children():
        i.queue_free()
    
    for i in Master.shops:
        var _shop_item:Panel = load("res://Scene/UI/ShopItem.tscn").instantiate()
        _shop_item.goods = Master.get_goods_by_info(i)
        contents.add_child(_shop_item)
    
