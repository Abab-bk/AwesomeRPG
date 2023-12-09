
#  <auto-generated>
#    This code was generated by a tool.
#    Changes to this file may cause incorrect behavior and will be lost if
#    the code is regenerated.
#  </auto-generated>

@tool
class_name Schema
extends RefCounted


enum BuffsEDataType
{
    MORE = 0,
    INCREASE = 1,
    COMPLEX_MORE = 2,
    COMPLEX_INCREASE = 3,
}


enum QuestsEQuestType
{
    ## 打怪
    KILL_ENEMY = 0,
    ## 打造装备
    ENHANCE_QUIPMENT = 1,
    ## 升级
    LEVEL_UP = 2,
    ## 挑战地牢
    BATTLE_DUNGEON = 3,
    ## 挑战地牢并成功
    BATTLE_DUNGEON_AND_SUCCESS = 4,
    ## 抽卡
    GACHA = 5,
    ## 爬塔
    CLIMB_TOWER = 6,
    ## 回收装备
    RECYCLE_EQUIPMENT = 7,
    ## 获得传奇装备
    GET_GOLD_EQUIPMENT = 8,
    ## 使用血瓶
    USE_HP_POTION = 9,
    ## 使用蓝瓶
    USE_MP_POTION = 10,
}


enum BuffsECostType
{
    HP = 0,
    MP = 1,
}


enum FriendQualityEquality
{
    N = 0,
    R = 1,
    SR = 2,
    SSR = 3,
    UR = 4,
}


enum RewardTypeReward
{
    NONE = 0,
    ## 金币
    COINS = 1,
    ## 经验
    XP = 2,
    ## 白钱
    MONEY_WHITE = 3,
    ## 蓝钱
    MONEY_BLUE = 4,
    ## 紫钱
    MONEY_PURPLE = 5,
    ## 黄钱
    MONEY_YELLOW = 6,
    ## 传奇装备
    GOLD_EQUIPMENT = 7,
    ## 飞升
    FLY = 8,
    ## 蓝色装备
    BLUE_EQUIPMENT = 9,
    ## 伙伴
    FRIEND = 10,
    ## 神恩石
    GACHA_MONEY = 11,
    ## 神恩石碎片
    GACHA_MONEY_PART = 12,
}


class Buffs:
    ## 这是id
    var id: int
    ## 名称
    var name: String
    ## 描述
    var desc: String
    ## 是否重复
    var repeat: bool
    ## 是否无限时间
    var infinite: bool
    ## 重复次数
    var repeat_count: int
    ## 准备时间
    var prepare_time: int
    ## 生效时间
    var active_time: int
    ## 冷却时间
    var cooldown_time: int
    ## 计算数据
    var compute_values: Array[BuffsComputeData]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.repeat = _json_["repeat"]
        self.infinite = _json_["infinite"]
        self.repeat_count = _json_["repeat_count"]
        self.prepare_time = _json_["prepare_time"]
        self.active_time = _json_["active_time"]
        self.cooldown_time = _json_["cooldown_time"]
        self.compute_values = []
        for _ele in _json_["compute_values"]: var _e: BuffsComputeData; _e = BuffsComputeData.new(_ele); self.compute_values.append(_e)


class BuffsComputeData:
    var id: String
    var type: int
    var value: float
    var formual: String
    var target_property: String

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.type = _json_["type"]
        self.value = _json_["value"]
        self.formual = _json_["formual"]
        self.target_property = _json_["target_property"]


class Affixs:
    var id: int
    var name: String
    var desc: String
    var target_buff_id: int
    var offset: Array[float]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.target_buff_id = _json_["target_buff_id"]
        self.offset = []
        for _ele in _json_["offset"]: var _e: float; _e = _ele; self.offset.append(_e)


class SkillTree:
    var id: int
    var name: String
    var desc: String
    var icon_path: String
    var cost: int
    var buff_id: int

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.icon_path = _json_["icon_path"]
        self.cost = _json_["cost"]
        self.buff_id = _json_["buff_id"]


class Abilitys:
    var id: int
    var name: String
    var desc: String
    var icon_path: String
    var cost: int
    var global: bool
    var cost_type: int
    var cost_value: float
    var cooldown: float
    var casting_time: float
    var running_time: float
    var long: bool
    var scene_name: String

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.icon_path = _json_["icon_path"]
        self.cost = _json_["cost"]
        self.global = _json_["global"]
        self.cost_type = _json_["cost_type"]
        self.cost_value = _json_["cost_value"]
        self.cooldown = _json_["cooldown"]
        self.casting_time = _json_["casting_time"]
        self.running_time = _json_["running_time"]
        self.long = _json_["long"]
        self.scene_name = _json_["scene_name"]


class Quests:
    var id: int
    var name: String
    var type: int
    var value: int
    var reward_type: int
    var reward: int

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.type = _json_["type"]
        self.value = _json_["value"]
        self.reward_type = _json_["reward_type"]
        self.reward = _json_["reward"]


class AbilityBuffs:
    ## 这是id
    var id: int
    ## 名称
    var name: String
    ## 描述
    var desc: String
    ## 是否重复
    var repeat: bool
    ## 是否无限时间
    var infinite: bool
    ## 重复次数
    var repeat_count: int
    ## 准备时间
    var prepare_time: int
    ## 生效时间
    var active_time: int
    ## 冷却时间
    var cooldown_time: int
    ## 计算数据
    var compute_values: Array[BuffsComputeData]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.repeat = _json_["repeat"]
        self.infinite = _json_["infinite"]
        self.repeat_count = _json_["repeat_count"]
        self.prepare_time = _json_["prepare_time"]
        self.active_time = _json_["active_time"]
        self.cooldown_time = _json_["cooldown_time"]
        self.compute_values = []
        for _ele in _json_["compute_values"]: var _e: BuffsComputeData; _e = BuffsComputeData.new(_ele); self.compute_values.append(_e)


class Enemys:
    var id: int
    var name: String
    var skin_name: String
    var hp: float
    var base_vision: float
    var base_atk_range: float
    var base_atk_cd: float
    var base_damage: float
    var fire_damage: float
    var frost_damage: float
    var toxic_damage: float
    var light_damage: float
    var fire_resistance: float
    var frost_resistance: float
    var toxic_resistance: float
    var light_resistance: float
    var speed: float

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.skin_name = _json_["skin_name"]
        self.hp = _json_["hp"]
        self.base_vision = _json_["base_vision"]
        self.base_atk_range = _json_["base_atk_range"]
        self.base_atk_cd = _json_["base_atk_cd"]
        self.base_damage = _json_["base_damage"]
        self.fire_damage = _json_["fire_damage"]
        self.frost_damage = _json_["frost_damage"]
        self.toxic_damage = _json_["toxic_damage"]
        self.light_damage = _json_["light_damage"]
        self.fire_resistance = _json_["fire_resistance"]
        self.frost_resistance = _json_["frost_resistance"]
        self.toxic_resistance = _json_["toxic_resistance"]
        self.light_resistance = _json_["light_resistance"]
        self.speed = _json_["speed"]


class Dungeons:
    var id: int
    var name: String
    var enemy_id: int
    var icon_path: String
    var reward_type: int
    var need_cost: int
    var reward_value: int
    var max_level: int

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.enemy_id = _json_["enemy_id"]
        self.icon_path = _json_["icon_path"]
        self.reward_type = _json_["reward_type"]
        self.need_cost = _json_["need_cost"]
        self.reward_value = _json_["reward_value"]
        self.max_level = _json_["max_level"]


class Goods:
    var id: int
    var name: String
    var desc: String

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]


class MainBuffs:
    var id: int
    var name: String
    var desc: String
    var target_buff_id: int
    var offset: Array[float]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.target_buff_id = _json_["target_buff_id"]
        self.offset = []
        for _ele in _json_["offset"]: var _e: float; _e = _ele; self.offset.append(_e)


class TalentBuffs:
    ## 这是id
    var id: int
    ## 名称
    var name: String
    ## 图标名称
    var icon_path: String
    ## 消耗天赋点
    var cost: int
    ## 是否重复
    var repeat: bool
    ## 是否无限时间
    var infinite: bool
    ## 重复次数
    var repeat_count: int
    ## 准备时间
    var prepare_time: int
    ## 生效时间
    var active_time: int
    ## 冷却时间
    var cooldown_time: int
    ## 计算数据
    var compute_values: Array[BuffsComputeData]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.icon_path = _json_["icon_path"]
        self.cost = _json_["cost"]
        self.repeat = _json_["repeat"]
        self.infinite = _json_["infinite"]
        self.repeat_count = _json_["repeat_count"]
        self.prepare_time = _json_["prepare_time"]
        self.active_time = _json_["active_time"]
        self.cooldown_time = _json_["cooldown_time"]
        self.compute_values = []
        for _ele in _json_["compute_values"]: var _e: BuffsComputeData; _e = BuffsComputeData.new(_ele); self.compute_values.append(_e)


class GoldNames:
    var id: int
    var name: String
    var type: String

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.type = _json_["type"]


class GoldBuffs:
    ## 这是id
    var id: int
    ## 名称
    var name: String
    ## 描述
    var desc: String
    ## 是否重复
    var repeat: bool
    ## 是否无限时间
    var infinite: bool
    ## 重复次数
    var repeat_count: int
    ## 准备时间
    var prepare_time: int
    ## 生效时间
    var active_time: int
    ## 冷却时间
    var cooldown_time: int
    ## 计算数据
    var compute_values: Array[BuffsComputeData]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.repeat = _json_["repeat"]
        self.infinite = _json_["infinite"]
        self.repeat_count = _json_["repeat_count"]
        self.prepare_time = _json_["prepare_time"]
        self.active_time = _json_["active_time"]
        self.cooldown_time = _json_["cooldown_time"]
        self.compute_values = []
        for _ele in _json_["compute_values"]: var _e: BuffsComputeData; _e = BuffsComputeData.new(_ele); self.compute_values.append(_e)


class GoldAffixs:
    var id: int
    var name: String
    var desc: String
    var target_buff_id: int
    var offset: Array[float]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.target_buff_id = _json_["target_buff_id"]
        self.offset = []
        for _ele in _json_["offset"]: var _e: float; _e = _ele; self.offset.append(_e)


class DungeonEnemy:
    var id: int
    var name: String
    var skin_name: String
    var hp: float
    var base_damage: float
    var fire_damage: float
    var frost_damage: float
    var toxic_damage: float
    var light_damage: float
    var fire_resistance: float
    var frost_resistance: float
    var toxic_resistance: float
    var light_resistance: float
    var speed: float

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.skin_name = _json_["skin_name"]
        self.hp = _json_["hp"]
        self.base_damage = _json_["base_damage"]
        self.fire_damage = _json_["fire_damage"]
        self.frost_damage = _json_["frost_damage"]
        self.toxic_damage = _json_["toxic_damage"]
        self.light_damage = _json_["light_damage"]
        self.fire_resistance = _json_["fire_resistance"]
        self.frost_resistance = _json_["frost_resistance"]
        self.toxic_resistance = _json_["toxic_resistance"]
        self.light_resistance = _json_["light_resistance"]
        self.speed = _json_["speed"]


class Friends:
    var id: int
    var name: String
    var icon_path: String
    var base_vision: float
    var base_atk_range: float
    var state_count: String
    var next_state_skin_name: String
    var quality: int
    var skin_name: String
    var hp: float
    var base_damage: float
    var fire_damage: float
    var frost_damage: float
    var toxic_damage: float
    var light_damage: float
    var fire_resistance: float
    var frost_resistance: float
    var toxic_resistance: float
    var light_resistance: float
    var speed: float

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.icon_path = _json_["icon_path"]
        self.base_vision = _json_["base_vision"]
        self.base_atk_range = _json_["base_atk_range"]
        self.state_count = _json_["state_count"]
        self.next_state_skin_name = _json_["next_state_skin_name"]
        self.quality = _json_["quality"]
        self.skin_name = _json_["skin_name"]
        self.hp = _json_["hp"]
        self.base_damage = _json_["base_damage"]
        self.fire_damage = _json_["fire_damage"]
        self.frost_damage = _json_["frost_damage"]
        self.toxic_damage = _json_["toxic_damage"]
        self.light_damage = _json_["light_damage"]
        self.fire_resistance = _json_["fire_resistance"]
        self.frost_resistance = _json_["frost_resistance"]
        self.toxic_resistance = _json_["toxic_resistance"]
        self.light_resistance = _json_["light_resistance"]
        self.speed = _json_["speed"]


class Gachas:
    ## 这是id
    var id: int
    ## 名称
    var name: String
    ## 奖励列表
    var reward_list: Array[RewardReward]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.reward_list = []
        for _ele in _json_["reward_list"]: var _e: RewardReward; _e = RewardReward.new(_ele); self.reward_list.append(_e)


class RewardReward:
    var type: int
    ## 对于随从，value为id
    var reward_value: int

    func _init(_json_) -> void:
        self.type = _json_["type"]
        self.reward_value = _json_["reward_value"]


class DayReward:
    ## 这是id
    var id: int
    ## 奖励列表
    var reward_list: Array[RewardReward]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.reward_list = []
        for _ele in _json_["reward_list"]: var _e: RewardReward; _e = RewardReward.new(_ele); self.reward_list.append(_e)


class OnlineReward:
    ## 这是id
    var id: int
    ## 需要时间（秒）
    var need_time: int
    ## 奖励列表
    var reward_list: Array[RewardReward]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.need_time = _json_["need_time"]
        self.reward_list = []
        for _ele in _json_["reward_list"]: var _e: RewardReward; _e = RewardReward.new(_ele); self.reward_list.append(_e)


class AllQuests:
    ## 这是id
    var id: int
    ## 描述
    var desc: String
    ## 任务类型
    var type: int
    ## 任务值范围
    var quest_value_range: Array[int]
    ## 奖励列表（随机挑一个）
    var reward_list: Array[RewardRangeReward]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.desc = _json_["desc"]
        self.type = _json_["type"]
        self.quest_value_range = []
        for _ele in _json_["quest_value_range"]: var _e: int; _e = _ele; self.quest_value_range.append(_e)
        self.reward_list = []
        for _ele in _json_["reward_list"]: var _e: RewardRangeReward; _e = RewardRangeReward.new(_ele); self.reward_list.append(_e)


class RewardRangeReward:
    var type: int
    ## 对于随从，value为id
    var reward_value: Array[int]

    func _init(_json_) -> void:
        self.type = _json_["type"]
        self.reward_value = []
        for _ele in _json_["reward_value"]: var _e: int; _e = _ele; self.reward_value.append(_e)


class BuffsTbBuffs:
    var _data_list: Array[Buffs]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Buffs
            _v = Buffs.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Buffs]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Buffs:
        return self._data_map.get(key)


class AffixsTbAffix:
    var _data_list: Array[Affixs]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Affixs
            _v = Affixs.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Affixs]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Affixs:
        return self._data_map.get(key)


class SkillTreeTbSkills:
    var _data_list: Array[SkillTree]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: SkillTree
            _v = SkillTree.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[SkillTree]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> SkillTree:
        return self._data_map.get(key)


class AbilitysTbAbilitys:
    var _data_list: Array[Abilitys]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Abilitys
            _v = Abilitys.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Abilitys]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Abilitys:
        return self._data_map.get(key)


class QuestsTbQuests:
    var _data_list: Array[Quests]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Quests
            _v = Quests.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Quests]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Quests:
        return self._data_map.get(key)


class AbilityBuffsTbAbilityBuffs:
    var _data_list: Array[AbilityBuffs]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: AbilityBuffs
            _v = AbilityBuffs.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[AbilityBuffs]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> AbilityBuffs:
        return self._data_map.get(key)


class EnemysTbEnemys:
    var _data_list: Array[Enemys]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Enemys
            _v = Enemys.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Enemys]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Enemys:
        return self._data_map.get(key)


class DungeonsTbDungeons:
    var _data_list: Array[Dungeons]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Dungeons
            _v = Dungeons.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Dungeons]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Dungeons:
        return self._data_map.get(key)


class GoodsTbGoods:
    var _data_list: Array[Goods]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Goods
            _v = Goods.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Goods]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Goods:
        return self._data_map.get(key)


class MainBuffsTbMainBuffs:
    var _data_list: Array[MainBuffs]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: MainBuffs
            _v = MainBuffs.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[MainBuffs]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> MainBuffs:
        return self._data_map.get(key)


class TalentBuffsTbTalentBuffs:
    var _data_list: Array[TalentBuffs]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: TalentBuffs
            _v = TalentBuffs.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[TalentBuffs]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> TalentBuffs:
        return self._data_map.get(key)


class GoldNamesTbGoldNames:
    var _data_list: Array[GoldNames]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: GoldNames
            _v = GoldNames.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[GoldNames]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> GoldNames:
        return self._data_map.get(key)


class GoldBuffsTbGoldBuffs:
    var _data_list: Array[GoldBuffs]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: GoldBuffs
            _v = GoldBuffs.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[GoldBuffs]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> GoldBuffs:
        return self._data_map.get(key)


class GoldAffixsTbGoldAffixs:
    var _data_list: Array[GoldAffixs]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: GoldAffixs
            _v = GoldAffixs.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[GoldAffixs]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> GoldAffixs:
        return self._data_map.get(key)


class DungeonEnemyTbDungeonEnemy:
    var _data_list: Array[DungeonEnemy]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: DungeonEnemy
            _v = DungeonEnemy.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[DungeonEnemy]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> DungeonEnemy:
        return self._data_map.get(key)


class FriendsTbFriends:
    var _data_list: Array[Friends]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Friends
            _v = Friends.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Friends]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Friends:
        return self._data_map.get(key)


class GachasTbGachas:
    var _data_list: Array[Gachas]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: Gachas
            _v = Gachas.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[Gachas]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> Gachas:
        return self._data_map.get(key)


class DaysRewardTbDaysReward:
    var _data_list: Array[DayReward]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: DayReward
            _v = DayReward.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[DayReward]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> DayReward:
        return self._data_map.get(key)


class OnlineRewardTbOnlineReward:
    var _data_list: Array[OnlineReward]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: OnlineReward
            _v = OnlineReward.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[OnlineReward]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> OnlineReward:
        return self._data_map.get(key)


class AllQuestsTbAllQuests:
    var _data_list: Array[AllQuests]
    var _data_map: Dictionary
    
    func _init(_json_) -> void:
        for _json2_ in _json_:
            var _v: AllQuests
            _v = AllQuests.new(_json2_)
            self._data_list.append(_v)
            self._data_map[_v.id] = _v

    func get_data_list() -> Array[AllQuests]:
        return self._data_list

    func get_data_map() -> Dictionary:
        return self._data_map

    func get_item(key) -> AllQuests:
        return self._data_map.get(key)


class CfgTables:
    var TbBuffs: BuffsTbBuffs
    var TbAffix: AffixsTbAffix
    var TbSkills: SkillTreeTbSkills
    var TbAbilitys: AbilitysTbAbilitys
    var TbQuests: QuestsTbQuests
    var TbAbilityBuffs: AbilityBuffsTbAbilityBuffs
    var TbEnemys: EnemysTbEnemys
    var TbDungeons: DungeonsTbDungeons
    var TbGoods: GoodsTbGoods
    var TbMainBuffs: MainBuffsTbMainBuffs
    var TbTalentBuffs: TalentBuffsTbTalentBuffs
    var TbGoldNames: GoldNamesTbGoldNames
    var TbGoldBuffs: GoldBuffsTbGoldBuffs
    var TbGoldAffixs: GoldAffixsTbGoldAffixs
    var TbDungeonEnemy: DungeonEnemyTbDungeonEnemy
    var TbFriends: FriendsTbFriends
    var TbGachas: GachasTbGachas
    var TbDaysReward: DaysRewardTbDaysReward
    var TbOnlineReward: OnlineRewardTbOnlineReward
    var TbAllQuests: AllQuestsTbAllQuests
    
    func _init(loader: Callable) -> void:
        self.TbBuffs = BuffsTbBuffs.new(loader.call('buffs_tbbuffs'))
        self.TbAffix = AffixsTbAffix.new(loader.call('affixs_tbaffix'))
        self.TbSkills = SkillTreeTbSkills.new(loader.call('skilltree_tbskills'))
        self.TbAbilitys = AbilitysTbAbilitys.new(loader.call('abilitys_tbabilitys'))
        self.TbQuests = QuestsTbQuests.new(loader.call('quests_tbquests'))
        self.TbAbilityBuffs = AbilityBuffsTbAbilityBuffs.new(loader.call('abilitybuffs_tbabilitybuffs'))
        self.TbEnemys = EnemysTbEnemys.new(loader.call('enemys_tbenemys'))
        self.TbDungeons = DungeonsTbDungeons.new(loader.call('dungeons_tbdungeons'))
        self.TbGoods = GoodsTbGoods.new(loader.call('goods_tbgoods'))
        self.TbMainBuffs = MainBuffsTbMainBuffs.new(loader.call('mainbuffs_tbmainbuffs'))
        self.TbTalentBuffs = TalentBuffsTbTalentBuffs.new(loader.call('talentbuffs_tbtalentbuffs'))
        self.TbGoldNames = GoldNamesTbGoldNames.new(loader.call('goldnames_tbgoldnames'))
        self.TbGoldBuffs = GoldBuffsTbGoldBuffs.new(loader.call('goldbuffs_tbgoldbuffs'))
        self.TbGoldAffixs = GoldAffixsTbGoldAffixs.new(loader.call('goldaffixs_tbgoldaffixs'))
        self.TbDungeonEnemy = DungeonEnemyTbDungeonEnemy.new(loader.call('dungeonenemy_tbdungeonenemy'))
        self.TbFriends = FriendsTbFriends.new(loader.call('friends_tbfriends'))
        self.TbGachas = GachasTbGachas.new(loader.call('gachas_tbgachas'))
        self.TbDaysReward = DaysRewardTbDaysReward.new(loader.call('daysreward_tbdaysreward'))
        self.TbOnlineReward = OnlineRewardTbOnlineReward.new(loader.call('onlinereward_tbonlinereward'))
        self.TbAllQuests = AllQuestsTbAllQuests.new(loader.call('allquests_tballquests'))
