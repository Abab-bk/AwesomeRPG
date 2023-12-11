class_name Reward extends Resource

enum REWARD_TYPE {
    NONE, # 0
    COINS, # 1
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


@export var type:REWARD_TYPE = REWARD_TYPE.NONE
@export var reward_value:int = 0

func get_reward(_show_popup:bool = true) -> String:
    match type:
        REWARD_TYPE.COINS:
            Master.coins += reward_value
        REWARD_TYPE.XP:
            Master.player.get_xp(reward_value)
        REWARD_TYPE.FLY:
            EventBus.unlock_new_function.emit("fly")
        REWARD_TYPE.MONEY_BLUE:
            Master.moneys.blue += reward_value
        REWARD_TYPE.MONEY_WHITE:
            Master.moneys.white += reward_value
        REWARD_TYPE.MONEY_PURPLE:
            Master.moneys.purple += reward_value
        REWARD_TYPE.MONEY_YELLOW:
            Master.moneys.yellow += reward_value
        REWARD_TYPE.GOLD_EQUIPMENT:
            var _generator:ItemGenerator = ItemGenerator.new()
            Master.world.add_child(_generator)
            
            for i in reward_value:
                Master.player_inventory.add_item(_generator.gen_a_item(true, true))
            _generator.queue_free()
            
        REWARD_TYPE.BLUE_EQUIPMENT:
            var _generator:ItemGenerator = ItemGenerator.new()
            Master.world.add_child(_generator)
            
            for i in reward_value:
                Master.player_inventory.add_item(_generator.gen_a_item(false, false))
            _generator.queue_free()
            
        REWARD_TYPE.FRIEND:
            EventBus.get_friend.emit(reward_value)
        REWARD_TYPE.GACHA_MONEY:
            Master.gacha_money += reward_value
        REWARD_TYPE.GACHA_MONEY_PART:
            Master.gacha_money_part += reward_value
        REWARD_TYPE.MEMORY:
            if reward_value in Master.memorys[reward_value]:
                Master.memorys[reward_value] = Master.memorys[reward_value] + 1
            else:
                Master.memorys[reward_value] = 1
                
        REWARD_TYPE.XP_BOOK_1:
            Master.xp_book_inventory[19] += reward_value
        REWARD_TYPE.XP_BOOK_2:
            Master.xp_book_inventory[20] += reward_value
        REWARD_TYPE.XP_BOOK_3:
            Master.xp_book_inventory[21] += reward_value
        REWARD_TYPE.XP_BOOK_4:
            Master.xp_book_inventory[22] += reward_value
            
        REWARD_TYPE.BOOK_SWORD:
            Master.pole_inventory[14] += reward_value
        REWARD_TYPE.BOOK_AXE:
            Master.pole_inventory[15] += reward_value
        REWARD_TYPE.BOOK_BOW:
            Master.pole_inventory[16] += reward_value
        REWARD_TYPE.BOOK_SPEAR:
            Master.pole_inventory[17] += reward_value
        REWARD_TYPE.BOOK_DAGGER:
            Master.pole_inventory[18] += reward_value
     
    var _return_text:String = ""
    
    if type == REWARD_TYPE.FRIEND:
        _return_text = Reward.get_string(type, reward_value)
    else:
        _return_text = "%s %s" % [str(reward_value), Reward.get_string(type)]        
    
    if _show_popup:
        EventBus.show_color.emit()
        EventBus.show_popup.emit("获得奖励！", "获得奖励：%s" % _return_text)
    
    return _return_text


static func get_reward_icon_path(_type:REWARD_TYPE) -> String:
    match _type:
        REWARD_TYPE.COINS:
            return "res://Assets/UI/Icons/Coins.svg"
        REWARD_TYPE.XP:
            return "res://Assets/UI/Icons/Coins.svg"
        REWARD_TYPE.FLY:
            return "res://Assets/UI/Icons/Coins.svg"
        REWARD_TYPE.MONEY_BLUE:
            return "res://Assets/UI/Icons/MoneyRed.png"
        REWARD_TYPE.MONEY_WHITE:
            return "res://Assets/UI/Icons/MoneyWhite.png"
        REWARD_TYPE.MONEY_PURPLE:
            return "res://Assets/UI/Icons/MoneyPurple.png"
        REWARD_TYPE.MONEY_YELLOW:
            return "res://Assets/UI/Icons/MoneyYellow.png"
        REWARD_TYPE.GOLD_EQUIPMENT:
            return "res://Assets/Texture/Icons/Sword/Sword1.png"
        REWARD_TYPE.BLUE_EQUIPMENT:
            return "res://Assets/Texture/Icons/Sword/Sword1.png"
        REWARD_TYPE.FRIEND:
            return "res://Assets/Characters/Friends/DarkElf2/Head.png"
        REWARD_TYPE.GACHA_MONEY:
            return "res://Assets/UI/Icons/GachaMoney.png"
        REWARD_TYPE.GACHA_MONEY_PART:
            return "res://Assets/UI/Icons/GachaMoneyPart.png"
        REWARD_TYPE.MEMORY:
            return "res://Assets/UI/Icons/Memory.png"
            
        REWARD_TYPE.XP_BOOK_1:
            return "res://Assets/UI/Icons/XpBook1.png"
        REWARD_TYPE.XP_BOOK_2:
            return "res://Assets/UI/Icons/XpBook2.png"
        REWARD_TYPE.XP_BOOK_3:
            return "res://Assets/UI/Icons/XpBook3.png"
        REWARD_TYPE.XP_BOOK_4:
            return "res://Assets/UI/Icons/XpBook4.png"
            
        REWARD_TYPE.BOOK_SWORD:
            return "res://Assets/UI/Icons/BookSword.png"
        REWARD_TYPE.BOOK_AXE:
            return "res://Assets/UI/Icons/BookAxe.png"
        REWARD_TYPE.BOOK_BOW:
            return "res://Assets/UI/Icons/BookBow.png"
        REWARD_TYPE.BOOK_DAGGER:
            return "res://Assets/UI/Icons/BookDagger.png"
        REWARD_TYPE.BOOK_SPEAR:
            return "res://Assets/UI/Icons/BookSpear.png"
    
    return "res://icon.svg"


static func get_string(_type, _reward_value = 1) -> String:
    var _result:String = ""
    
    match _type:
        REWARD_TYPE.COINS:
            _result = "金币"
        REWARD_TYPE.XP:
            _result = "经验"
        REWARD_TYPE.FLY:
            _result = "解锁飞升"
        REWARD_TYPE.MONEY_BLUE:
            _result = "天堂之灰"
        REWARD_TYPE.MONEY_WHITE:
            _result = "奉献之灰"
        REWARD_TYPE.MONEY_PURPLE:
            _result = "赦罪之血"
        REWARD_TYPE.MONEY_YELLOW:
            _result = "天使之泪" 
        REWARD_TYPE.GOLD_EQUIPMENT:
            _result = "传奇装备"
        REWARD_TYPE.BLUE_EQUIPMENT:
            _result = "稀有装备"
            
        REWARD_TYPE.FRIEND:
            _result = Master.friends[_reward_value]["name"]
        REWARD_TYPE.GACHA_MONEY:
            _result = "神恩石"
        REWARD_TYPE.GACHA_MONEY_PART:
            _result = "神恩石碎片"
            
        REWARD_TYPE.XP_BOOK_1:
            _result = "普通经验书"
        REWARD_TYPE.XP_BOOK_2:
            _result = "高级经验书"
        REWARD_TYPE.XP_BOOK_3:
            _result = "史诗经验书"
        REWARD_TYPE.XP_BOOK_4:
            _result = "传奇经验书"
    
        REWARD_TYPE.BOOK_SWORD:
            _result = "剑之诗"            
        REWARD_TYPE.BOOK_AXE:
            _result = "斧之诗"
        REWARD_TYPE.BOOK_BOW:
            _result = "弓之诗"
        REWARD_TYPE.BOOK_DAGGER:
            _result = "匕首之诗"
        REWARD_TYPE.BOOK_SPEAR:
            _result = "枪之诗"
    
    return _result
