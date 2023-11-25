class_name AffixItem extends Resource

@export var name:String
@export var desc:String
@export var target_buff_id:int
@export var offset:float

var buff:FlowerBaseBuff = FlowerBaseBuff.new()

func update_desc(_data) -> void:
    if offset <= 1.0 and buff.compute_values[0].type == FlowerConst.COMPUTE_TYPE.MORE or buff.compute_values[0].type == FlowerConst.COMPUTE_TYPE.COMPLEX_MORE:
        #desc = _data.desc.format({"s": str(floor(offset * 10))}) # *10 是为了显示正常，因为实际数据是 0.1 - 1.0
        desc = _data.desc.format({"s": str(offset * 10).pad_decimals(2)})
        #print("物品值：", buff.compute_values)
    else:
        desc = _data.desc.format({"s": str(offset).pad_decimals(2)})

func update(_data) -> void:
    buff.name = name
    buff.desc = desc
    
    if target_buff_id >= 10000:
        var _gold_buff = Master.gold_buffs[target_buff_id]
        
        buff.repeat = _gold_buff["repeat"]
        buff.infinite = _gold_buff["infinite"]
        buff.repeat_count = _gold_buff["repeat_count"]
        buff.prepare_time = _gold_buff["prepare_time"]
        buff.active_time = _gold_buff["active_time"]
        buff.cooldown_time = _gold_buff["cooldown_time"]
        
        buff.compute_values = _get_compute_datas(_gold_buff["compute_values"])
        
        update_desc(_data)
        
        return
    
    var _buff = Master.buffs[target_buff_id]
    
    buff.repeat = _buff["repeat"]
    buff.infinite = _buff["infinite"]
    buff.repeat_count = _buff["repeat_count"]
    buff.prepare_time = _buff["prepare_time"]
    buff.active_time = _buff["active_time"]
    buff.cooldown_time = _buff["cooldown_time"]
    
    buff.compute_values = _get_compute_datas(_buff["compute_values"])
    
    update_desc(_data)

func _get_compute_datas(_value) -> Array[FlowerComputeData]:
    var _result:Array[FlowerComputeData] = []
    
    for i in _value:
        var _new_data:FlowerComputeData = FlowerComputeData.new()
        _new_data.id = i["id"]
        _new_data.type = i["type"]
        _new_data.value = offset
        _new_data.target_property = i["target_property"]
        
        _result.append(_new_data)
        
    return _result
