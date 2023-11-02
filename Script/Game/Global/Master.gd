extends Node

# TODO: 装备打造系统
# TODO: 副本、每日任务、爬塔模式

const BGM:String = "res://Assets/Sounds/Music/Bgm.wav"
const CLICK_SOUNDS:String = "res://Assets/Sounds/Click.mp3"
const POPUP_SOUNDS:String = "res://Assets/Sounds/PopUp.mp3"
const HURT_SOUNDS:String = "res://Assets/Sounds/Sfx/Hurt.wav"
const HIT_SOUNDS:String = "res://Assets/Sounds/Sfx/Hit.mp3"
const HAPPY_SOUNDS:String = "res://Assets/Sounds/Sfx/Happy.ogg"

const SPECIAL_ABILITYS_ID:Array[int] = [4005]

var world:Node2D

var player:Player
var player_data:CharacterData
var player_output_data:CharacterData
var relife_point:Marker2D
var unlocked_skills:Array[int] = []

# 关卡等级：
var current_level:int = 0

var player_name:String = "花神"

var coins:int = 1000:
    set(v):
        coins = v
        EventBus.coins_changed.emit()

var next_reward_player_level:int = 1

var config

var affixs:Array
var buffs:Dictionary
var abilitys:Dictionary
var quests:Dictionary

var json_path:String = "res://DataBase/output/"

const abilitys_start:int = 4001
const abilitys_end:int = 4006

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
    
    return _ability

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
