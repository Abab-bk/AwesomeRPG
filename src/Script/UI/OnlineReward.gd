extends Control

@onready var items:VBoxContainer = %Items


func _ready() -> void:
    var _child:PackedScene = Prefab.create(%OnlineRewardItem)
    
    for i in Master.online_rewards.keys():
        items.add_child(_child.instantiate())
        items.target_time = TimeManager.get_current_time_resource()
