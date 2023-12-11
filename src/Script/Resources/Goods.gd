class_name Goods extends Resource

signal buyed

@export var name:String = ""
@export var reward:Reward
@export var cost_type:Const.MONEY_TYPE
@export var cost:int


func try_to_buy() -> void:
    match cost_type:
        Const.MONEY_TYPE.COIN:
            if Master.coins < cost:
                EventBus.new_tips.emit("金币不足")
                return
            show_buy_popup(func():
                Master.coins -= cost
                reward.get_reward())
            
        Const.MONEY_TYPE.GACHA_MONEY_PART:
            if Master.gacha_money_part < cost:
                EventBus.new_tips.emit("碎片不足")
                return
            show_buy_popup(func():
                Master.gacha_money_part -= cost
                reward.get_reward())

        Const.MONEY_TYPE.AD:
            if Master.today_watch_ad_count >= Const.MAX_AD_COUNT:
                EventBus.new_tips.emit("今日观看次数已达上限")
                return
            show_buy_popup(func():
                Master.today_watch_ad_count += 1
                reward.get_reward()
                )


func show_buy_popup(_buy_event:Callable) -> void:
    EventBus.show_popup.emit("购买", "确定购买吗？将花费 %s %s" % [str(cost), get_cost_string()],
    true, func():
        _buy_event.call()
        buyed.emit()
        EventBus.update_ui.emit()
        , func():pass)


func get_cost_string() -> String:
    match cost_type:
        Const.MONEY_TYPE.COIN:
            return "金币"
        Const.MONEY_TYPE.GACHA_MONEY_PART:
            return "神恩石碎片"
        Const.MONEY_TYPE.AD:
            return "广告"
    return ""
