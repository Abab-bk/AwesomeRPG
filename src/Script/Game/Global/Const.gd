class_name Const extends Node

const IMAGES:Dictionary = {
    "WhatIcon": "res://Assets/UI/Texture/WhatIcon.png"
}

const MAX_AD_COUNT:int = 10

const SOUNDS:Dictionary = {
    "MonsterAttack": "res://Assets/Sounds/Sfx/MonsterAttack.ogg",
    "CollectReward": "res://Assets/Sounds/Sfx/CollectReward.ogg",
    "WindUp": "res://Assets/Sounds/Sfx/WindUp.ogg",
    "CollectCoin": "res://Assets/Sounds/Sfx/CollectCoin.ogg",
    "BGM": "res://Assets/Sounds/Music/SoothingBackyard.ogg",
    "BattleBgm": "res://Assets/Sounds/Music/Action.ogg",
    "Victory": "res://Assets/Sounds/Sfx/Victory.ogg",
    "Death": "res://Assets/Sounds/Sfx/Death.ogg",
}

enum MONEY_TYPE {
    NONE, # 0
    COIN, # 1
    XP, # 2
    MONEY_WHITE, # 3
    MONEY_BLUE, # 4
    MONEY_PURPLE, # 5
    MONEY_YELLOW, # 6
    GOLD_EQUIPMENT, # 7
    FLY, # 飞升, # 8
    BLUE_EQUIPMENT, # 9
    FRIEND, # 10
    GACHA_MONEY, # 11
    GACHA_MONEY_PART, # 12
    MEMORY, # 13
    BOOK_SWORD,# 14
    BOOK_AXE,# 15
    BOOK_SPEAR,# 16
    BOOK_DAGGER,# 17
    BOOK_BOW,# 18
    XP_BOOK_1,# 19
    XP_BOOK_2,# 20
    XP_BOOK_3,# 21
    XP_BOOK_4,# 22
    AD, # 23
}


const RARITY_WEIGHT:Dictionary = {
    "white": 0.8,
}


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

const PROPERTY_INFO:Dictionary = {
    "level": "等级",
    "now_xp": "当前经验",
    "next_level_xp": "下一级所需经验",
    "hp": "生命值",
    "max_hp": "最大生命值",
    "magic": "魔法值",
    "max_magic": "最大魔法值",
    "strength": "力量",
    "wisdom": "智慧",
    "agility": "敏捷",
    "luck": "幸运",
    "speed": "速度",
    "damage": "伤害",
    "defense": "防御",
    "fire_damage": "火焰伤害",
    "frost_damage": "冰霜伤害",
    "light_damage": "闪电伤害",
    "toxic_damage": "毒素伤害",
    "fire_resistance": "火焰抗性",
    "frost_resistance": "冰霜抗性",
    "light_resistance": "闪电抗性",
    "toxic_resistance": "毒素抗性",
    "physical_resistance": "物理抗性",
    "critical_rate": "暴击率",
    "critical_damage": "暴击伤害",
    "vulnerability_rate": "易伤率",
    "vulnerability_damage": "易伤伤害",
    "evasion": "闪避",
    "health_regeneration": "生命恢复",
    "healing_effciency": "回复效率",
    "weapon_damage": "武器伤害",
    "vision": "视野",
    "atk_speed": "攻击速度",
    "atk_cd": "攻击冷却时间",
    "atk_range": "攻击范围"
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

enum FRIEND_QUALITY {
    N,
    R,
    SR,
    SSR,
    UR
}

enum LOCATIONS {
    WORLD,
    TOWER,
    DUNGEON,
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


static func get_money_icon_path(_type:MONEY_TYPE) -> String:
    var _result:String = ""
    return Reward.get_reward_icon_path(int(_type))
