extends Node

# TODO: 装备打造系统

const CLICK_SOUNDS = "res://Assets/Sounds/Click.mp3"
const POPUP_SOUNDS = "res://Assets/Sounds/PopUp.mp3"

var world:Node2D

var player:Player
var player_data:CharacterData
var relife_point:Marker2D
var unlocked_skills:Array[int] = []

var coins:int = 0:
    set(v):
        coins = v
        EventBus.coins_changed.emit()

var config

var affixs:Array
var buffs:Dictionary
var abilitys:Dictionary
var quests:Dictionary

var json_path:String = "res://DataBase/output/"

const abilitys_start:int = 4001
const abilitys_end:int = 4004

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
    var _ability:FlowerAbility = load("res://Script/Abilitys/%s.gd" % _data["script_name"]).new()
    
    _ability.id = _data.id
    _ability.name = _data.name
    _ability.desc = _data.desc
    _ability.icon_path = _data.icon_path
    _ability.cooldown = _data.cooldown
    _ability.casting_time = _data.casting_time
    
    return _ability

func get_random_ability_id() -> int:
    return abilitys[randi_range(abilitys_start, abilitys_end)]

func get_random_ability() -> FlowerAbility:
    var _data = abilitys[randi_range(abilitys_start, abilitys_end)]
    var _ability:FlowerAbility = load("res://Script/Abilitys/%s.gd" % _data["script_name"]).new()
    
    _ability.id = _data.id
    _ability.name = _data.name
    _ability.desc = _data.desc
    _ability.icon_path = _data.icon_path
    _ability.cooldown = _data.cooldown
    _ability.casting_time = _data.casting_time
    
    return _ability

# 生成随机词缀
func get_random_affix() -> AffixItem:
    var _affix:AffixItem = AffixItem.new()
    var _data = affixs[randi_range(0, affixs.size() - 1)]
    
    _affix.name = _data.name
    _affix.target_buff_id = _data.target_buff_id
    
    var _offset:float = randf_range(_data.offset[0], _data.offset[1])
    # 决定词缀描述
    # HACK: 临时修复？ - 词缀如果是 INC 类型也会 * 10，导致显示错误
    if _offset <= 1.0:
        _affix.desc = _data.desc.format({"s": str(floor(_offset * 10))}) # *10 是为了显示正常，因为实际数据是 0.1 - 1.0
    else:
        _affix.desc = _data.desc.format({"s": str(floor(_offset))})
    
    _affix.offset = _offset
    
    _affix.update()
    
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
