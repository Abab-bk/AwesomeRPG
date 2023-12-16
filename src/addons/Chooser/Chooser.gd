class_name Chooser extends RefCounted

## 选择列表，包含Array，包含的Array例子：[thing, weight] （第一个元素为任何变量，第二个元素为权重，权重可以是任何 [正数]，在pick函数中动态比较）
@export var chooser_list:Array[Array] = []


func _init(_chooser_list:Array[Array] = []) -> void:
    chooser_list = _chooser_list


func clear() -> void:
    chooser_list.clear()


func add_item(_item:Variant, _weight:float) -> void:
    chooser_list.append([_item, _weight])


func pick() -> Variant:
    var _result:Variant = null
    
    if chooser_list.is_empty():
        return _result
    
    var _total_weight:float = 0.0
    for _item in chooser_list:
        _total_weight += abs(_item[1])
    
    if _total_weight == 0:
        return null
    
    var _random_weight:float = randf() * _total_weight
    var _result_list:Array = []
    
    var _current_weight:float = 0.0
    for _item in chooser_list:
        _current_weight += abs(_item[1])
        if _random_weight <= _current_weight:
            _result_list.append(_item[0])
    
    _result = _result_list.pick_random()
    return _result
