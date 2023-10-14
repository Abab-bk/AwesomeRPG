class_name AffixItem extends Resource

var name:String
var desc:String
var target_buff_id:int
var offset:float

var buff:FlowerBaseBuff = FlowerBaseBuff.new()

func update() -> void:
    buff.name = name
    buff.desc = desc
    
    var _buff = Master.buffs[target_buff_id]
    
    buff.repeat = _buff["repeat"]
    buff.infinite = _buff["infinite"]
    buff.repeat_count = _buff["repeat_count"]
    buff.prepare_time = _buff["prepare_time"]
    buff.active_time = _buff["active_time"]
    buff.cooldown_time = _buff["cooldown_time"]
    
    buff.compute_values = _get_compute_datas(_buff["compute_values"])

func _get_compute_datas(_value) -> Array[FlowerComputeData]:
    var _result:Array[FlowerComputeData]
    
    for i in _value:
        var _new_data:FlowerComputeData = FlowerComputeData.new()
        _new_data.id = i["id"]
        _new_data.type = i["type"]
        _new_data.value = offset
        _new_data.target_property = i["target_property"]
        
        _result.append(_new_data)
        
    return _result
