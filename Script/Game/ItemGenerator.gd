class_name ItemGenerator extends Node

func gen_a_item() -> InventoryItem:
    var _new_item:InventoryItem = InventoryItem.new()
    _new_item.name = ""
    
    # 随机掉落词缀数量
    var count:int = randi_range(1, 5)
    for i in count:
        _new_item.affixs.append(Master.get_random_affix())
    
    for i in _new_item.affixs:
        _new_item.name += i.name
    
    _new_item.name += "剑"
    
    return _new_item
