extends Node

# TODO: 每日任务、换装备对比Tooltip
# TODO: 飞升技能树
# TODO: 每日转盘（转的越多奖励越好）
# TODO: 世界树（花园）
# TODO: 程序化生成世界地图
# HACK: 升级音效短一点
# FIXME: 任务做到一定程度，就完不成咯

const BGM:String = "res://Assets/Sounds/Music/KleptoLindaMountainA.wav"
const CLICK_SOUNDS:String = "res://Assets/Sounds/Click.mp3"
const POPUP_SOUNDS:String = "res://Assets/Sounds/PopUp.mp3"
const HURT_SOUNDS:String = "res://Assets/Sounds/Sfx/Hurt.wav"
const HIT_SOUNDS:String = "res://Assets/Sounds/Sfx/Hit.mp3"
const HAPPY_SOUNDS:String = "res://Assets/Sounds/Sfx/Happy.ogg"
const SOUNDS = {
    "Myster": "res://Assets/Sounds/Sfx/Mystery.wav",
    "GachaItemShow": "res://Assets/Sounds/Sfx/GachaItemShow.wav",
    "Forge": "res://Assets/Sounds/Sfx/Forge.wav"
}

const SPECIAL_ABILITYS_ID:Array[int] = [4005]
const ENEMYS_SKINS:Array[String] = [
    "res://Scene/Perfabs/NonPlayCharacter/GitanSkeleton1.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/GitanSkeleton2.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/GitanSkeleton3.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/Mummy1.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/Mummy2.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/Mummy3.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/Skeleton2.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/Skeleton3.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/SkeletonArcher2.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/SkeletonArcher3.tscn",
    "res://Scene/Perfabs/NonPlayCharacter/SkeletonArcher.tscn"
]

var world:Node2D

var player_healing_items:Dictionary = {
    "hp_potion": 0,
    "mp_potion": 0,
}:
    set(v):
        player_healing_items = v
        FlowerSaver.set_data("player_healing_items", player_healing_items)

var player_inventory:Inventory
var player:Player
var player_data:CharacterData
var player_output_data:CharacterData
var player_camera:Camera2D
var relife_point:Marker2D
var unlocked_skills:Array = []:
    set(v):
        unlocked_skills = v
        FlowerSaver.set_data("unlocked_skills", unlocked_skills)

var should_load:bool = false

var in_dungeon:bool = false

# 关卡等级：
var current_level:int = 1:
    set(v):
        current_level = v
        FlowerSaver.set_data("current_level", current_level)
# 进入下一关需要击杀的怪物数量
var next_level_need_kill_count:int = 0
# 转生次数
var fly_count:int = 0:
    set(v):
        fly_count = v
        FlowerSaver.set_data("fly_count", fly_count)
var flyed_just_now:bool = false:
    set(v):
        flyed_just_now = v
        FlowerSaver.set_data("flyed_just_now", flyed_just_now)
var player_name:String = "花神":
    set(v):
        FlowerSaver.set_data("player_name", player_name)

var current_location:Const.LOCATIONS = Const.LOCATIONS.WORLD

var current_tower_level:int = 0
var last_tallest_tower_level:int = 0
var need_kill_enemys_to_next_tower:int = 10

var coins:int = 1000:
    set(v):
        coins = max(v, 0)
        FlowerSaver.set_data("coins", coins)
        EventBus.coins_changed.emit()
var moneys:Dictionary = {
    "white": 0,
    "blue": 0,
    "purple": 0,
    "yellow": 0,
}:
    set(v):
        moneys = v
        FlowerSaver.set_data("moneys", moneys)
var gacha_money:int = 0:
    set(v):
        gacha_money = v
        FlowerSaver.set_data("gacha_money", gacha_money)
var gacha_money_part:int = 0:
    set(v):
        gacha_money_part = v
        FlowerSaver.set_data("gacha_money_part", gacha_money_part)

var last_checkin_time:TimeResource = TimeResource.new(0, 0, 0):
    set(v):
        last_checkin_time = v
        FlowerSaver.set_data("last_checkin_time", last_checkin_time)
var last_leave_time:TimeResource = TimeResource.new(0, 0, 0):
    set(v):
        last_leave_time = v
        FlowerSaver.set_data("last_leave_time", last_leave_time)

var next_reward_player_level:int = 1:
    set(v):
        next_reward_player_level = v
        FlowerSaver.set_data("next_reward_player_level", next_reward_player_level)

# 用来存储drop_item位置的数组
var occupied_positions:Array

var current_save_slot:String

var config

var affixs:Array
var buffs:Dictionary
var talent_buffs:Dictionary
var ability_trees:Dictionary
var abilitys:Dictionary
var quests:Dictionary
var ability_buffs:Dictionary
var dungeons:Dictionary
var enemys:Dictionary
var dungeon_enemys:Dictionary
var main_buffs:Array
var gold_affixs:Array
var gold_buffs:Dictionary
var gold_names:Array
var friends:Dictionary
var gachas:Dictionary
var days_checkin:Dictionary
var online_rewards:Dictionary


var unlocked_functions:Dictionary = {
    "fly": false
}:
    set(v):
        unlocked_functions = v
        FlowerSaver.set_data("unlocked_functions", unlocked_functions)


var json_path:String = "res://DataBase/output/"

var subscriber:TraceSubscriber = (
    TraceSubscriber
    .new()
    .with_nicer_colors(false))

const abilitys_start:int = 4002
const abilitys_end:int = 4009


func _ready():
    config = Schema.CfgTables.new(loader)
    
    affixs = config.TbAffix.get_data_list()
    buffs = config.TbBuffs.get_data_map()
    abilitys = config.TbAbilitys.get_data_map()
    quests = config.TbQuests.get_data_map()
    ability_buffs = config.TbAbilityBuffs.get_data_map()
    enemys = config.TbEnemys.get_data_map()
    dungeons = config.TbDungeons.get_data_map()
    main_buffs = config.TbMainBuffs.get_data_list()
    talent_buffs = config.TbTalentBuffs.get_data_map()
    gold_buffs = config.TbGoldBuffs.get_data_map()
    gold_names = config.TbGoldNames.get_data_list()
    gold_affixs = config.TbGoldAffixs.get_data_list()
    dungeon_enemys = config.TbDungeonEnemy.get_data_map()
    friends = config.TbFriends.get_data_map()
    gachas = config.TbGachas.get_data_map()
    days_checkin = config.TbDaysReward.get_data_map()
    online_rewards = config.TbOnlineReward.get_data_map()
    #ability_trees = config.TbSkills.get_data_map()
    #goods = config.TbGoods.get_data_map()

    EventBus.unlock_new_function.connect(func(_key:String):
        match _key:
            "fly":
                unlocked_functions.fly = true
        )

    EventBus.unlocked_ability.connect(func(_id:int):
        if _id in unlocked_skills:
            return
        unlocked_skills.append(_id)
        )
    
    EventBus.completed_level.connect(func():
        current_level += 1
        EventBus.update_ui.emit()
        )
    
    EventBus.player_level_up.connect(func():
        if player.compute_data.level >= next_reward_player_level:
            var _ability:FlowerAbility = Master.get_random_ability()
            EventBus.unlocked_ability.emit(_ability.id)
            EventBus.show_popup.emit("升级！获得奖励", "解锁技能：%s" % _ability.name)
            next_reward_player_level += 5
        )
    
    EventBus.save.connect(func():
        FlowerSaver.set_data("unlocked_functions", unlocked_functions)
        FlowerSaver.set_data("next_reward_player_level", next_reward_player_level)
        FlowerSaver.set_data("last_leave_time", last_leave_time)
        FlowerSaver.set_data("last_checkin_time", last_checkin_time)
        FlowerSaver.set_data("moneys", moneys)
        )
    
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("flyed_just_now"):
            flyed_just_now = FlowerSaver.get_data("flyed_just_now")
        
        if flyed_just_now:
            Tracer.info("Master飞升读档，玩家名：%s" % player_name)
            fly_count = FlowerSaver.get_data("fly_count")
            unlocked_skills = []
            current_level = 0
            coins = 0
            moneys = {"white": 0, "blue": 0, "purple": 0, "yellow": 0,}
            next_reward_player_level = 1
            player_healing_items = {"hp_potion": 0, "mp_potion": 0, }
            
            player_data = null
            player_output_data = null
            
            player_inventory = null
            
            in_dungeon = false
            
            #EventBus.rework_level_enemy_count.emit()
            EventBus.completed_level.emit()
            return
        
        Tracer.info("Master常规读档")
        
        if FlowerSaver.has_key("fly_count"):
            fly_count = FlowerSaver.get_data("fly_count")
        
        if FlowerSaver.has_key("unlocked_skills"):
            unlocked_skills = FlowerSaver.get_data("unlocked_skills")
        
        if FlowerSaver.has_key("current_level"):
            current_level = FlowerSaver.get_data("current_level")
        
        if FlowerSaver.has_key("player_name"):
            player_name = FlowerSaver.get_data("player_name")
        
        if FlowerSaver.has_key("coins"):
            coins = FlowerSaver.get_data("coins")
        
        if FlowerSaver.has_key("moneys"):
            moneys = FlowerSaver.get_data("moneys")
        
        if FlowerSaver.has_key("next_reward_player_level"):
            next_reward_player_level = FlowerSaver.get_data("next_reward_player_level")
        
        if FlowerSaver.has_key("last_checkin_time"):
            last_checkin_time = FlowerSaver.get_data("last_checkin_time")
        
        if FlowerSaver.has_key("last_leave_time"):
            last_leave_time = FlowerSaver.get_data("last_leave_time")
        
        if FlowerSaver.has_key("player_healing_items"):
            player_healing_items = FlowerSaver.get_data("player_healing_items")
        
        if FlowerSaver.has_key("unlocked_functions"):
            unlocked_functions = FlowerSaver.get_data("unlocked_functions")

        if FlowerSaver.has_key("gacha_money"):
            gacha_money = FlowerSaver.get_data("gacha_money")
            
        if FlowerSaver.has_key("gacha_money_part"):
            gacha_money_part = FlowerSaver.get_data("gacha_money_part")

        
        EventBus.rework_level_enemy_count.emit()
        )
    
    EventBus.get_money.connect(func(_key:String, _value:int):
        moneys[_key] += _value
        )
    EventBus.player_get_healing_potion.connect(func(_key:String, num:int):
        if _key == "hp":
            if player_healing_items.hp_potion >= 10:
                return
            player_healing_items.hp_potion += num
            return
        if _key == "mp":
            if player_healing_items.mp_potion >= 10:
                return
            player_healing_items.mp_potion += num
            return
        )
    EventBus.start_climb_tower.connect(func():
        current_location = Const.LOCATIONS.TOWER
        EventBus.update_ui.emit()
        )
    EventBus.go_to_next_tower_level.connect(func():
        current_tower_level += 1
        EventBus.update_ui.emit()
        )
    EventBus.exit_tower.connect(func():
        last_tallest_tower_level = current_tower_level
        current_location = Const.LOCATIONS.WORLD
        get_tower_reward()
        current_tower_level = 1
        need_kill_enemys_to_next_tower = 10
        )
        
    subscriber.init()


func yes_fly() -> void:
    coins = 0
    unlocked_skills = []
    current_level = 0
    moneys.white = 0
    moneys.blue = 0
    moneys.purple = 0
    moneys.yellow = 0
    in_dungeon = false    

func get_player_level_up_info() -> Dictionary:
    var _result:Dictionary
    
    var _form_data:CharacterData = player_data.duplicate(true) as CharacterData
    
    _form_data.level -= 1
    _result = _form_data.level_up()
    
    return _result


func get_days_reward_list_by_id(_id:int) -> Array[Reward]:
    var _list:Array[Reward] = []
    var _data = days_checkin[_id]
    
    for i in _data["reward_list"]:
        var _reward:Reward = Reward.new()
        _reward.type = i["type"]
        _reward.reward_value = i["reward_value"]
        _list.append(_reward)
    
    return _list


func get_online_reward_list_by_id(_id:int) -> Array[Reward]:
    var _list:Array[Reward] = []
    var _data = online_rewards[_id]
    
    for i in _data["reward_list"]:
        var _reward:Reward = Reward.new()
        _reward.type = i["type"]
        _reward.reward_value = i["reward_value"]
        _list.append(_reward)
    
    return _list


func get_base_gacha_pool() -> GachaPool:
    var _gacha_pool:GachaPool = GachaPool.new()
    var _data = gachas[1001]
    
    _gacha_pool.name = _data["name"]
    
    for i in _data["reward_list"]:
        var _reward:Reward = Reward.new()
        _reward.type = i["type"]
        _reward.reward_value = i["reward_value"]
        _gacha_pool.reward_list.append(_reward)
    
    return _gacha_pool


func get_gacha_pool_by_id(_id:int) -> GachaPool:
    var _gacha_pool:GachaPool = GachaPool.new()
    var _data = gachas[_id]
    
    _gacha_pool.name = _data["name"]
    
    for i in _data["reward_list"]:
        var _reward:Reward = Reward.new()
        _reward.type = i["type"]
        _reward.reward_value = i["reward_value"]
        _gacha_pool.reward_list.append(_reward)
    
    return _gacha_pool


func get_friend_data_by_id(_id:int) -> FriendData:
    var _friend:FriendData = FriendData.new()
    
    var _data = friends[_id]
    
    _friend.id = _id
    _friend.icon_path = _data["icon_path"]
    _friend.name = _data["name"]
    _friend.quality = _data["quality"]
    _friend.skin_name = _data["skin_name"]
    
    return _friend

func get_dungeon_by_id(_id:int) -> DungeonData:
    var _dungeon:DungeonData = DungeonData.new()
    
    _dungeon.id = dungeons[_id]["id"]
    _dungeon.name = dungeons[_id]["name"]
    _dungeon.enemy_id = dungeons[_id]["enemy_id"]
    _dungeon.reward_type = dungeons[_id]["reward_type"]
    _dungeon.base_cost = dungeons[_id]["need_cost"]
    _dungeon.base_reward = dungeons[_id]["reward_value"]
    _dungeon.max_level = dungeons[_id]["max_level"]
    _dungeon.icon_path = "res://Assets/Texture/Images/%s" % dungeons[_id]["icon_path"]
    
    _dungeon.set_level(1)
    
    return _dungeon

func get_quest_by_id(_id:int) -> QuestResource:
    var _quest:QuestResource = QuestResource.new()
    
    var _data = quests[_id]
    _quest.id = _data["id"]
    _quest.name = _data["name"]
    _quest.type = _data["type"]
    _quest.need_value = _data["value"]
    _quest.reward_value = _data["reward"]
    _quest.reward_type = _data["reward_type"]
    
    return _quest

func get_ability_by_id(_id:int) -> FlowerAbility:
    var _data = abilitys[_id]
    var _ability:FlowerAbility = FlowerAbility.new()
#    var _ability:FlowerAbility = load("res://Script/Abilitys/%s.gd" % _data["script_name"]).new()
    
    _ability.id = _data.id
    _ability.name = _data.name
    _ability.desc = _data.desc
    _ability.icon_path = "res://Assets/Texture/Icons/Skills/%s" % _data.icon_path
    _ability.cooldown = _data.cooldown
    _ability.casting_time = _data.casting_time
    _ability.running_time = _data.running_time
    _ability.global = _data.global
    _ability.scene = load("res://Scene/Perfabs/Abilitys/%s.tscn" % _data.scene_name)
    _ability.cost = _data.cost
    _ability.cost_type = _data.cost_type
    _ability.cost_value = _data.cost_value
    
    return _ability

func get_talent_buff_by_id(_target_buff_id:int) -> FlowerBaseBuff:
    var buff:FlowerBaseBuff = FlowerBaseBuff.new()
    var _buff = talent_buffs[_target_buff_id]
    
    buff.name = _buff.name
    buff.desc = ""
    buff.repeat = _buff["repeat"]
    buff.infinite = _buff["infinite"]
    buff.repeat_count = _buff["repeat_count"]
    buff.prepare_time = _buff["prepare_time"]
    buff.active_time = _buff["active_time"]
    buff.cooldown_time = _buff["cooldown_time"]
    
    buff.compute_values = _get_compute_datas(_buff["compute_values"])
    
    return buff

func get_buff_by_id(_target_buff_id:int) -> FlowerBaseBuff:
    var buff:FlowerBaseBuff = FlowerBaseBuff.new()
    var _buff = ability_buffs[_target_buff_id]
    
    buff.name = _buff.name
    buff.desc = _buff.desc
    buff.repeat = _buff["repeat"]
    buff.infinite = _buff["infinite"]
    buff.repeat_count = _buff["repeat_count"]
    buff.prepare_time = _buff["prepare_time"]
    buff.active_time = _buff["active_time"]
    buff.cooldown_time = _buff["cooldown_time"]
    
    buff.compute_values = _get_compute_datas(_buff["compute_values"])
    
    return buff


func get_random_gold_name() -> String:
    return gold_names.pick_random().name



func _get_compute_datas(_value) -> Array[FlowerComputeData]:
    var _result:Array[FlowerComputeData] = []
    
    for i in _value:
        var _new_data:FlowerComputeData = FlowerComputeData.new()
        _new_data.id = i["id"]
        _new_data.type = i["type"]
        _new_data.value = i["value"]
        _new_data.formual = i["formual"]
        _new_data.target_property = i["target_property"]
        
        _result.append(_new_data)
        
    return _result


func get_random_ability_id() -> int:
#    var _rng:FairNG = FairNG.new(abilitys_end)
#    return abilitys[_rng.randi()]["id"]
    return abilitys[randi_range(abilitys_start, abilitys_end)]["id"]


func get_random_ability() -> FlowerAbility:
    var _data = abilitys[randi_range(abilitys_start, abilitys_end)]
#    var _ability:FlowerAbility = load("res://Script/Abilitys/%s.gd" % _data["scene_name"]).new()
    var _ability:FlowerAbility = FlowerAbility.new()
    
    _ability.id = _data.id
    _ability.name = _data.name
    _ability.desc = _data.desc
    _ability.icon_path = _data.icon_path
    _ability.cooldown = _data.cooldown
    _ability.casting_time = _data.casting_time
    _ability.running_time = _data.running_time
    _ability.global = _data.global
    _ability.scene = load("res://Scene/Perfabs/Abilitys/%s.tscn" % _data.scene_name)
    _ability.cost = _data.cost
    _ability.cost_type = _data.cost_type
    _ability.cost_value = _data.cost_value
    
    return _ability


func get_random_main_affix() -> AffixItem:
    var _affix:AffixItem = AffixItem.new()
    randomize()
    var _data = main_buffs[randi_range(0, main_buffs.size() - 1)]
    
    _affix.name = _data.name
    _affix.target_buff_id = _data.target_buff_id
    
    var _offset:float = randf_range(_data.offset[0], _data.offset[1])
    # 决定词缀描述
    # HACK: 临时修复？ - 词缀如果是 INC 类型也会 * 10，导致显示错误
    
    _affix.offset = _offset
    
    _affix.update(_data)
    
    return _affix


# 生成随机词缀
func get_random_affix() -> AffixItem:
    var _affix:AffixItem = AffixItem.new()
    randomize()
    var _data = affixs[randi_range(0, affixs.size() - 1)]
    
    _affix.name = _data.name
    _affix.target_buff_id = _data.target_buff_id
    
    var _offset:float = randf_range(_data.offset[0], _data.offset[1])
    # 决定词缀描述
    # HACK: 临时修复？ - 词缀如果是 INC 类型也会 * 10，导致显示错误
    
    _affix.offset = _offset
    
    _affix.update(_data)
    
    return _affix


func get_random_gold_affix() -> AffixItem:
    var _affix:AffixItem = AffixItem.new()
    randomize()
    var _data = gold_affixs.pick_random()
    
    _affix.name = _data.name
    _affix.target_buff_id = _data.target_buff_id
    
    var _offset:float = randf_range(_data.offset[0], _data.offset[1])
    # 决定词缀描述
    # HACK: 临时修复？ - 词缀如果是 INC 类型也会 * 10，导致显示错误
    
    _affix.offset = _offset
    
    _affix.update(_data)
    
    return _affix


#func get_random_gold_buff() -> FlowerBaseBuff:
    #var buff:FlowerBaseBuff = FlowerBaseBuff.new()
    #var _buff = gold_buffs.pick_random()
    #
    #buff.name = _buff.name
    #buff.desc = _buff.desc
    #buff.repeat = _buff["repeat"]
    #buff.infinite = _buff["infinite"]
    #buff.repeat_count = _buff["repeat_count"]
    #buff.prepare_time = _buff["prepare_time"]
    #buff.active_time = _buff["active_time"]
    #buff.cooldown_time = _buff["cooldown_time"]
    #
    #buff.compute_values = _get_compute_datas(_buff["compute_values"])
    #
    #return buff

func get_rate_text_color_from_item(_item:InventoryItem) -> Color:
        if not _item:
            return Color(0, 0, 0)
        
        var _result:Color
        
        match _item.quality:
            Const.EQUIPMENT_QUALITY.NORMAL:
                _result = Color("D9DBD8")
            Const.EQUIPMENT_QUALITY.BLUE:
                _result = Color("D9DBD8")
            Const.EQUIPMENT_QUALITY.YELLOW:
                _result = Color("D9DBD8")
            Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
                _result = Color("D9DBD8")
            Const.EQUIPMENT_QUALITY.GOLD:
                _result = Color("D9DBD8")
        
        return _result

func get_rate_text_from_item(_item:InventoryItem) -> String:
        if not _item:
            return ""
        
        var _result = ""
        
        match _item.quality:
            Const.EQUIPMENT_QUALITY.NORMAL:
                _result += "普通"
            Const.EQUIPMENT_QUALITY.BLUE:
                _result += "稀有"
            Const.EQUIPMENT_QUALITY.YELLOW:
                _result += "魔法"
            Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
                _result += "史诗"
            Const.EQUIPMENT_QUALITY.GOLD:
                _result += "传奇"
        
        if _item.type == Const.EQUIPMENT_TYPE.武器:
            match _item.weapon_type:
                Const.WEAPONS_TYPE.Sword:
                    _result += "剑"
                Const.WEAPONS_TYPE.Axe:
                    _result += "斧"
                Const.WEAPONS_TYPE.Hammer:
                    _result += "锤"
                Const.WEAPONS_TYPE.Shield:
                    _result += "盾"
        elif _item.type == Const.EQUIPMENT_TYPE.远程武器:
            match _item.ranged_weapon_type:
                Const.RANGED_WEAPONS_TYPE.Bow:
                    _result += "弓"
                Const.RANGED_WEAPONS_TYPE.Spear:
                    _result += "法杖"
                Const.RANGED_WEAPONS_TYPE.Staff:
                    _result += "短杖"
        else:
            _result += str(Const.EQUIPMENT_TYPE.keys()[_item.type])
        
        return _result


func loader(file_name:String):
    var json_file = FileAccess.open(self.json_path + file_name + ".json", FileAccess.READ)
    var json_text = json_file.get_as_text()
    json_file.close()
    return JSON.parse_string(json_text)


func get_tower_reward() -> void:
    var _rewards:Dictionary = {}
    
    if Master.current_tower_level <= 10:
        _rewards["金币"] = current_tower_level * 5
    if Master.current_tower_level >= 20:
        _rewards["金币"] = current_tower_level * 10
        _rewards["奉献之灰"] = current_level * 1
    if Master.current_tower_level >= 30:
        _rewards["金币"] = current_tower_level * 15
        _rewards["奉献之灰"] = current_level * 1
        _rewards["天堂之灰"] = current_level * 1
    if Master.current_tower_level >= 40:
        _rewards["金币"] = current_tower_level * 20
        _rewards["奉献之灰"] = current_level * 1
        _rewards["天堂之灰"] = current_level * 1
        _rewards["赦罪之血"] = current_level * 1
    if Master.current_tower_level >= 50:
        _rewards["金币"] = current_tower_level * 25
        _rewards["奉献之灰"] = current_level * 1
        _rewards["天堂之灰"] = current_level * 1
        _rewards["赦罪之血"] = current_level * 1
        _rewards["天使之泪"] = current_level * 1        
    if Master.current_tower_level >= 60:
        _rewards["金币"] = current_tower_level * 30
        _rewards["奉献之灰"] = (current_level - 40) * current_level
        _rewards["天堂之灰"] = (current_level - 40) * current_level
        _rewards["赦罪之血"] = (current_level - 40) * current_level
        _rewards["天使之泪"] = (current_level - 40) * current_level
    
    for i in _rewards.keys():
        get_reward(i, _rewards[i])
    
    EventBus.show_popup.emit("获得奖励", "爬到了 %s 层，获得奖励：
    %s
    " % [str(current_tower_level), get_reward_label_from_dic(_rewards)])


func get_reward(_key:String, _value:int) -> void:
    match _key:
        "金币":
            coins += _value
        "奉献之灰":
            moneys.white += _value
        "天堂之灰":
            moneys.blue += _value
        "赦罪之血":
            moneys.purple += _value
        "天使之泪":
            moneys.yellow += _value


func get_reward_label_from_dic(_data:Dictionary) -> String:
    var _result:String =  ""
    
    for key in _data.keys():
        _result += "%s：%s" % [key, _data[key]]
    
    return _result


func get_offline_reward() -> void:
    var _distance:int = TimeManager.get_current_time_resource().get_distance_to_a(last_leave_time)
    
    var _level:int = Master.player.get_level() - 1
    
    var _get_xp:float = (((3 * _level * 1.5) * (1 + Master.fly_count * 0.1)) * 0.8) * float(_distance)
    var _get_coins:int = floor((_level * randi_range(0, 5)) * 0.8) * _distance
    
    Master.coins += _get_coins
    Master.player.get_xp(_get_xp)
    
    EventBus.show_popup.emit("离线奖励", """
    离线奖励：
    金币 %s
    经验 %s
    """ % [str(_get_coins), str(_get_xp).pad_decimals(0)])


func _notification(_what:int) -> void:
    if _what == NOTIFICATION_WM_CLOSE_REQUEST:
        last_leave_time = TimeManager.get_current_time_resource()
        EventBus.save.emit()
    if _what == NOTIFICATION_WM_GO_BACK_REQUEST:
        last_leave_time = TimeManager.get_current_time_resource()
        EventBus.save.emit()
