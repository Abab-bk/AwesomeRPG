class_name ItemGenerator extends Node

func gen_a_item() -> InventoryItem:
    var _new_item:InventoryItem = InventoryItem.new()
    _new_item.name = ""
    _new_item.type = randi_range(0, Const.EQUIPMENT_TYPE.values().size() - 1)
    
    match _new_item.type:
        Const.EQUIPMENT_TYPE.头盔:
            _new_item.name += "头盔"
        Const.EQUIPMENT_TYPE.护腕:
            _new_item.name += "护腕"
        Const.EQUIPMENT_TYPE.手套:
            _new_item.name += "手套"
        Const.EQUIPMENT_TYPE.靴子:
            _new_item.name += "靴子"
        Const.EQUIPMENT_TYPE.胸甲:
            _new_item.name += "胸甲"
        Const.EQUIPMENT_TYPE.皮带:
            _new_item.name += "皮带"
        Const.EQUIPMENT_TYPE.裤子:
            _new_item.name += "裤子"
        Const.EQUIPMENT_TYPE.护身符:
            _new_item.name += "护身符"
        Const.EQUIPMENT_TYPE.戒指:
            _new_item.name += "戒指"
        Const.EQUIPMENT_TYPE.武器:
            _new_item.name += "武器"
    
    # 随机掉落词缀数量
    var count:int = randi_range(1, 5)
    for i in count:
        _new_item.affixs.append(Master.get_random_affix())
    
    for i in _new_item.affixs:
        _new_item.name += i.name
    
    return _new_item
