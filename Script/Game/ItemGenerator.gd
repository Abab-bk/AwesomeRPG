class_name ItemGenerator extends Node

const AXES:String = "res://Assets/Texture/Icons/Axes/"
const BOWS:String = "res://Assets/Texture/Icons/Bows/"
const DAGGERS:String = "res://Assets/Texture/Icons/Daggers/"
const HAMMERS:String = "res://Assets/Texture/Icons/Hammers/"
const SWORDS:String = "res://Assets/Texture/Icons/Sword/"
const POLES:String = "res://Assets/Texture/Icons/Poles/"
const SPEARS:String = "res://Assets/Texture/Icons/Spears/"
const STAFFS:String = "res://Assets/Texture/Icons/Staffs/"
const SHIELDS:String = "res://Assets/Texture/Icons/Shields/"
const 头盔:String = "res://Assets/Texture/Icons/头盔/"
const 胸甲:String = "res://Assets/Texture/Icons/胸甲/"
const 手套:String = "res://Assets/Texture/Icons/手套/"
const 靴子:String = "res://Assets/Texture/Icons/靴子/"
const 皮带:String = "res://Assets/Texture/Icons/皮带/"
const 裤子:String = "res://Assets/Texture/Icons/裤子/"
const 护身符:String = "res://Assets/Texture/Icons/护身符/"
const 戒指:String = "res://Assets/Texture/Icons/戒指/"

func gen_a_item() -> InventoryItem:
    randomize()
    # 掉落装备
    var _new_item:InventoryItem = InventoryItem.new()
    _new_item.name = "{pre}"
    _new_item.type = Const.EQUIPMENT_TYPE.values()[randi() % Const.EQUIPMENT_TYPE.size()]
    
    match _new_item.type:
        Const.EQUIPMENT_TYPE.远程武器:
            match _new_item.ranged_weapon_type:
                Const.RANGED_WEAPONS_TYPE.Bow:
                    _new_item.name += "弓"            
                    _new_item.texture_path = get_random_icon_path(BOWS)
                Const.RANGED_WEAPONS_TYPE.Spear:
                    _new_item.name += "法杖"            
                    _new_item.texture_path = get_random_icon_path(SPEARS)
                Const.RANGED_WEAPONS_TYPE.Staff:
                    _new_item.name += "短杖"            
                    _new_item.texture_path = get_random_icon_path(STAFFS)
        
        Const.EQUIPMENT_TYPE.头盔:
            _new_item.name += "头盔"
            _new_item.texture_path = get_random_icon_path(头盔)
        Const.EQUIPMENT_TYPE.手套:
            _new_item.name += "手套"
            _new_item.texture_path = get_random_icon_path(手套)
        Const.EQUIPMENT_TYPE.靴子:
            _new_item.name += "靴子"
            _new_item.texture_path = get_random_icon_path(靴子)
        Const.EQUIPMENT_TYPE.胸甲:
            _new_item.name += "胸甲"
            _new_item.texture_path = get_random_icon_path(胸甲)
        Const.EQUIPMENT_TYPE.皮带:
            _new_item.name += "皮带"
            _new_item.texture_path = get_random_icon_path(皮带)
        Const.EQUIPMENT_TYPE.裤子:
            _new_item.name += "裤子"
            _new_item.texture_path = get_random_icon_path(裤子)
        Const.EQUIPMENT_TYPE.护身符:
            _new_item.name += "护身符"
            _new_item.texture_path = get_random_icon_path(护身符)
        Const.EQUIPMENT_TYPE.戒指:
            _new_item.name += "戒指"
            _new_item.texture_path = get_random_icon_path(戒指)
        Const.EQUIPMENT_TYPE.武器:
            _new_item.weapon_type = Const.WEAPONS_TYPE.values()[randi() % Const.WEAPONS_TYPE.size()]
            
            # TODO: 更改随机值
            match _new_item.weapon_type:
                Const.WEAPONS_TYPE.Sword:
                    _new_item.name += "剑"            
                    _new_item.texture_path = get_random_icon_path(SWORDS)
                Const.WEAPONS_TYPE.Axe:
                    _new_item.texture_path = get_random_icon_path(AXES)
                    _new_item.name += "斧"            
                Const.WEAPONS_TYPE.Hammer:
                    _new_item.name += "锤"            
                    _new_item.texture_path = get_random_icon_path(HAMMERS)
                Const.WEAPONS_TYPE.Shield:
                    _new_item.name += "盾"            
                    _new_item.texture_path = get_random_icon_path(SHIELDS)
    
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
        Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
            count = 5
        Const.EQUIPMENT_QUALITY.GOLD:
            count = 5
    
    _new_item.main_buffs = Master.get_random_main_affix()
    
    for i in count:
        var _pre_or_buf:int = randi_range(0, 1)
        match _pre_or_buf:
            0:
                _new_item.pre_affixs.append(Master.get_random_affix())
            1:
                _new_item.buf_affix.append(Master.get_random_affix())
    
    _new_item.name += "{buf}"
    
    if _new_item.pre_affixs.size() > 0:
        _new_item.name = _new_item.name.format({"pre": str(_new_item.pre_affixs[0].name) + " "})
    else:
        _new_item.name = _new_item.name.format({"pre": ""})
    
    if _new_item.buf_affix.size() > 0:
        _new_item.name = _new_item.name.format({"buf": " " + str(_new_item.buf_affix[0].name)}) 
    else:
        _new_item.name = _new_item.name.format({"buf": ""}) 
    
    # 物品价格公式
    _new_item.price = (int(quality) + 1) * 10 * count
    
    return _new_item

func get_random_icon_path(_dir_path:String) -> String:
    var dir = DirAccess.open(_dir_path)
    var names:Array = []
    
    for i in dir.get_files():
        if "import" in i:
            var x = i.replace(".import", "")
            names.append(x)
    
    var _file_name = names[randi_range(0, names.size() - 1)]
    return _dir_path + "/" + _file_name
