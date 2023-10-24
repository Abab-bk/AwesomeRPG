class_name ItemGenerator extends Node

func gen_a_item() -> InventoryItem:
    # 掉落装备
    var _new_item:InventoryItem = InventoryItem.new()
    _new_item.name = ""
    _new_item.type = Const.EQUIPMENT_TYPE.values()[randi() % Const.EQUIPMENT_TYPE.size()]
    
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
    # 根据随机的品质修改词缀数量：
    var quality:Const.EQUIPMENT_QUALITY = Const.EQUIPMENT_QUALITY.values()[randi()%Const.EQUIPMENT_QUALITY.size()]
    _new_item.quality = quality
    
    var count:int
    
    match quality:
        Const.EQUIPMENT_QUALITY.NORMAL:
            count = 0
        Const.EQUIPMENT_QUALITY.BLUE:
            count = 1
        Const.EQUIPMENT_QUALITY.YELLOW:
            count = randi_range(3, 4)
        Const.EQUIPMENT_QUALITY.DEEP_YELLO:
            count = 5
        Const.EQUIPMENT_QUALITY.GOLD:
            count = 5
    
    for i in count:
        var _pre_or_buf:int = randi_range(0, 1)
        match _pre_or_buf:
            0:
                _new_item.pre_affixs.append(Master.get_random_affix())
            1:
                _new_item.buf_affix.append(Master.get_random_affix())
    
    for i in _new_item.pre_affixs:
        _new_item.name += i.name
    for i in _new_item.buf_affix:
        _new_item.name += i.name
    
    # 物品价格公式
    _new_item.price = (int(quality) + 1) * 10 * count
    
    return _new_item
