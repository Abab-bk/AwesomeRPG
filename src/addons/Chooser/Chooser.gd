class_name Chooser extends Node

## 选择列表，包含Array，包含的Array例子：[thing, weight] （第一个元素为任何变量，第二个元素为权重，权重可以是任何 [正数]，在pick函数中动态比较）
@export var chooser_list:Array[Array] = []


func _init(_chooser_list:Array[Array] = []) -> void:
    chooser_list = _chooser_list


func pick() -> Variant:
    var _result:Variant = null
    
    # 检查是否有可选项
    if chooser_list.is_empty():
        return _result
    
    # 计算总权重
    var _total_weight:float = 0.0
    for _item in chooser_list:
        _total_weight += abs(_item[1])
    
    if _total_weight == 0:
        return null
    
    # 生成随机权重值
    var _random_weight:float = randf() * _total_weight

    # 遍历列表，选择符合权重的元素
    var _current_weight:float = 0.0
    for _item in chooser_list:
        _current_weight += abs(_item[1])
        if _random_weight <= _current_weight:
            _result = _item[0]
            break
    
    return _result
