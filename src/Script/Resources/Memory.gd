class_name Memory extends Resource

@export var target_id:int = 0
@export var num:int = 0

func _init(_target_id:int = 0, _num:int = 0) -> void:
    target_id = _target_id
    num = _num