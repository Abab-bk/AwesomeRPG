
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
}


enum BuffsECostType
{
    HP = 0,
    MP = 1,
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
    var next_skill_id: int
    var child_skills: Array[int]

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.desc = _json_["desc"]
        self.next_skill_id = _json_["next_skill_id"]
        self.child_skills = []
        for _ele in _json_["child_skills"]: var _e: int; _e = _ele; self.child_skills.append(_e)


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
    var reward: int

    func _init(_json_) -> void:
        self.id = _json_["id"]
        self.name = _json_["name"]
        self.type = _json_["type"]
        self.value = _json_["value"]
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


class CfgTables:
    var TbBuffs: BuffsTbBuffs
    var TbAffix: AffixsTbAffix
    var TbSkills: SkillTreeTbSkills
    var TbAbilitys: AbilitysTbAbilitys
    var TbQuests: QuestsTbQuests
    var TbAbilityBuffs: AbilityBuffsTbAbilityBuffs
    
    func _init(loader: Callable) -> void:
        self.TbBuffs = BuffsTbBuffs.new(loader.call('buffs_tbbuffs'))
        self.TbAffix = AffixsTbAffix.new(loader.call('affixs_tbaffix'))
        self.TbSkills = SkillTreeTbSkills.new(loader.call('skilltree_tbskills'))
        self.TbAbilitys = AbilitysTbAbilitys.new(loader.call('abilitys_tbabilitys'))
        self.TbQuests = QuestsTbQuests.new(loader.call('quests_tbquests'))
        self.TbAbilityBuffs = AbilityBuffsTbAbilityBuffs.new(loader.call('abilitybuffs_tbabilitybuffs'))

