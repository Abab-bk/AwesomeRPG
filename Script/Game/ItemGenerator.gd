class_name ItemGenerator extends Node


const AXES:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_arrow.png", "res://Assets/Texture/Weapons/weapon_axe.png", "res://Assets/Texture/Weapons/weapon_axe_blades.png", "res://Assets/Texture/Weapons/weapon_axe_double.png", "res://Assets/Texture/Weapons/weapon_axe_large.png"
]
const BOWS:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_bow.png", "res://Assets/Texture/Weapons/weapon_bow_arrow.png"
]
const DAGGERS:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_dagger.png"
]
const HAMMERS:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_hammer.png"
]
const SWORDS:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_longsword.png", "res://Assets/Texture/Weapons/weapon_sword.png"
]
const POLES:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_pole.png"
]
const SPEARS:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_spear.png"
]
const STAFFS:Array[String] = [
    "res://Assets/Texture/Weapons/weapon_staff.png"
]
const SHIELDS:Array[String] = [
    "res://Assets/Texture/Weapons/shield_curved.png", "res://Assets/Texture/Weapons/shield_straight.png"
]

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
            _new_item.weapon_type = Const.WEAPONS_TYPE.values()[randi() % Const.WEAPONS_TYPE.size()]
            
            match _new_item.weapon_type:
                Const.WEAPONS_TYPE.Sword:
                    _new_item.texture_path = SWORDS[randi_range(0, SWORDS.size() - 1)]
                Const.WEAPONS_TYPE.Axe:
                    _new_item.texture_path = AXES[randi_range(0, AXES.size() - 1)]
                Const.WEAPONS_TYPE.Bow:
                    _new_item.texture_path = BOWS[randi_range(0, BOWS.size() - 1)]
                Const.WEAPONS_TYPE.Hammer:
                    _new_item.texture_path = HAMMERS[randi_range(0, HAMMERS.size() - 1)]
                Const.WEAPONS_TYPE.Spear:
                    _new_item.texture_path = SPEARS[randi_range(0, SPEARS.size() - 1)]
                Const.WEAPONS_TYPE.Staff:
                    _new_item.texture_path = STAFFS[randi_range(0, STAFFS.size() - 1)]
                Const.WEAPONS_TYPE.Shield:
                    _new_item.texture_path = SHIELDS[randi_range(0, SHIELDS.size() - 1)]
            
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
        Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
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
