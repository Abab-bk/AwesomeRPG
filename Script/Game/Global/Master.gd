extends Node

# TODO: 装备打造系统
# TODO: 每日任务、爬塔模式

const BGM:String = "res://Assets/Sounds/Music/Bgm.wav"
const CLICK_SOUNDS:String = "res://Assets/Sounds/Click.mp3"
const POPUP_SOUNDS:String = "res://Assets/Sounds/PopUp.mp3"
const HURT_SOUNDS:String = "res://Assets/Sounds/Sfx/Hurt.wav"
const HIT_SOUNDS:String = "res://Assets/Sounds/Sfx/Hit.mp3"
const HAPPY_SOUNDS:String = "res://Assets/Sounds/Sfx/Happy.ogg"

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

var player_inventory:Inventory
var player:Player
var player_data:CharacterData
var player_output_data:CharacterData
var relife_point:Marker2D
var unlocked_skills:Array[int] = []

var in_dungeon:bool = false

# 关卡等级：
var current_level:int = 0
# 转生次数
var fly_count:int = 0
var player_name:String = "花神"

var coins:int = 1000:
    set(v):
        coins = v
        EventBus.coins_changed.emit()
var moneys:Dictionary = {
    "white": 0,
    "blue": 0,
    "purle": 0,
    "yellow": 0,
}

var next_reward_player_level:int = 1

var config

var affixs:Array
var buffs:Dictionary
var abilitys:Dictionary
var quests:Dictionary
var ability_buffs:Dictionary
var dungeons:Dictionary
var enemys:Dictionary
var goods:Dictionary

var json_path:String = "res://DataBase/output/"

const abilitys_start:int = 4001
const abilitys_end:int = 4008

func get_dungeon_by_id(_id:int) -> DungeonData:
    var _dungeon:DungeonData = DungeonData.new()
    
    _dungeon.id = dungeons[_id]["id"]
    _dungeon.name = dungeons[_id]["name"]
    _dungeon.enemy_id = dungeons[_id]["enemy_id"]
    _dungeon.reward_type = dungeons[_id]["reward_type"]
    _dungeon.need_cost = dungeons[_id]["need_cost"]
    _dungeon.reward_value = dungeons[_id]["reward_value"]
    
    return _dungeon

func get_quest_by_id(_id:int) -> QuestResource:
    var _quest:QuestResource = QuestResource.new()
    
    var _data = quests[_id]
    _quest.id = _data["id"]
    _quest.name = _data["name"]
    _quest.type = _data["type"]
    _quest.need_value = _data["value"]
    _quest.reward_value = _data["reward"]
    
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

func _get_compute_datas(_value) -> Array[FlowerComputeData]:
    var _result:Array[FlowerComputeData] = []
    
    for i in _value:
        var _new_data:FlowerComputeData = FlowerComputeData.new()
        _new_data.id = i["id"]
        _new_data.type = i["type"]
        _new_data.value = i["value"]
        _new_data.formual = i.formual
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

func loader(file_name:String):
    var json_file = FileAccess.open(self.json_path + file_name + ".json", FileAccess.READ)
    var json_text = json_file.get_as_text()
    json_file.close()
    return JSON.parse_string(json_text)

func _ready():
    config = Schema.CfgTables.new(loader)
    
    affixs = config.TbAffix.get_data_list()
    buffs = config.TbBuffs.get_data_map()
    abilitys = config.TbAbilitys.get_data_map()
    quests = config.TbQuests.get_data_map()
    ability_buffs = config.TbAbilityBuffs.get_data_map()
    enemys = config.TbEnemys.get_data_map()
    dungeons = config.TbDungeons.get_data_map()
    #goods = config.TbGoods.get_data_map()

    EventBus.unlocked_ability.connect(func(_id:int):
        if _id in unlocked_skills:
            return
        unlocked_skills.append(_id)
        )
    
    EventBus.completed_level.connect(func():
        current_level += 1
        )
    
    EventBus.player_level_up.connect(func():
        if player.compute_data.level >= next_reward_player_level:
            var _ability:FlowerAbility = Master.get_random_ability()
            EventBus.unlocked_ability.emit(_ability.id)
            EventBus.show_popup.emit("升级！获得奖励", "解锁技能：%s" % _ability.name)
            next_reward_player_level += 5
        )
