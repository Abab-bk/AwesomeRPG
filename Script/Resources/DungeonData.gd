class_name DungeonData extends Resource

@export var id:int
@export var name:String
@export var enemy_id:int
@export var reward_type:String
@export var need_cost:int
@export var reward_value:int
@export var max_level:int = 1
@export var current_level:int = 1

var base_cost:int
var base_reward:int

func set_level(_level:int) -> void:
    if current_level >= max_level:
        current_level = max_level
        return
    
    current_level = _level
    need_cost = base_cost * current_level
    reward_value = base_reward * current_level

func next_level() -> void:
    if current_level >= max_level:
        current_level = max_level
        return
    
    current_level += 1
    
    name = Master.dungeons[id]["name"] + " Lv.%s" % str(current_level)
    
    need_cost = base_cost * current_level
    reward_value = base_reward * current_level

func previous_level() -> void:
    if current_level <= 1:
        current_level = 1
        return
    
    current_level -= 1
    
    name = Master.dungeons[id]["name"] + " Lv.%s" % str(current_level)
    
    need_cost = base_cost * current_level
    reward_value = base_reward * current_level
