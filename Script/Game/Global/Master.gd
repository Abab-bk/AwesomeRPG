extends Node

var player:CharacterBody2D
var relife_point:Marker2D

var config
var affixs:Array
var buffs:Dictionary
var json_path:String = "res://DataBase/output/"

func get_random_affix() -> AffixItem:
    var _affix:AffixItem = AffixItem.new()
    var _data = affixs[randi_range(0, affixs.size() - 1)]
    
    _affix.name = _data.name
    _affix.target_buff_id = _data.target_buff_id
    
    var _offset:int = randi_range(_data.offset[0], _data.offset[1])
    _affix.desc = _data.desc.format({"s": str(_offset)})
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
