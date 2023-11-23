class_name Const extends Node

const MONEYS_NAME:Dictionary = {
    "white": "奉献之灰",
    "blue": "天堂之尘",
    "purple": "赦罪之血",
    "yellow": "天使之泪"
}

const COLORS:Dictionary = {
    "Normal": Color("757575"),
    "Blue": Color("7896BA"),
    "Yellow": Color("366F42"),
    "DeepYellow": Color("543460"),
    "Gold": Color("C3A438"),
}

enum EQUIPMENT_TYPE {
    头盔,
    胸甲,
    手套,
    靴子,
    皮带,
    裤子,
    护身符,
    戒指,
    武器,
    远程武器
}

enum RANGED_WEAPONS_TYPE {
    Spear,
    Staff,
    Bow,
}

enum WEAPONS_TYPE {
    Sword,
    Axe,
    Hammer,
    Shield
}

enum EQUIPMENT_QUALITY {
    NORMAL,
    BLUE,
    YELLOW,
    DEEP_YELLOW,
    GOLD
}
