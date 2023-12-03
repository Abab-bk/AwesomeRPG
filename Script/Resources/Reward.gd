class_name Reward extends Resource

enum REWARD_TYPE {
    NONE,
    COINS,
    XP,
    MONEY_WHITE,
    MONEY_BLUE,
    MONEY_PURPLE,
    MONEY_YELLOW,
    GOLD_EQUIPMENT,
    FLY # 飞升
}


@export var type:REWARD_TYPE = REWARD_TYPE.NONE
@export var reward_value:int = 0

func get_reward() -> void:
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
            Master.world.dd_child(_generator)
            
            for i in reward_value:
                _generator.gen_a_item(true, true)
            _generator.queue_free()

    EventBus.show_popup.emit("获得奖励！", "获得奖励：%s %s" % [str(reward_value), Reward.get_string(type)])


static func get_string(_type) -> String:
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
    
    return _result
