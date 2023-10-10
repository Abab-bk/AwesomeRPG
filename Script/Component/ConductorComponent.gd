class_name ConductorComponent extends Node

@export var blackboard:Blackboard
@export var buff_manager:FlowerBuffManager
@export var atk_range:AtkRangeComponent
@export var vision:VisionComponent
@export var weapons:Node2D
@export var atk_cd_timer:Timer

func _ready() -> void:
    blackboard.set_value("atk_range", atk_range)
    blackboard.set_value("vision", vision)
    blackboard.set_value("data", buff_manager.compute_data)
    blackboard.set_value("weapons", weapons)
    blackboard.set_value("atk_cd_timer", atk_cd_timer)
    
