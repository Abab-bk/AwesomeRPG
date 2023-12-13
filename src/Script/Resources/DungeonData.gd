class_name DungeonData extends Resource

@export var id:int
@export var name:String
@export var enemy_id:int
@export var reward_type:int
@export var need_cost:int
@export var reward_value:int
@export var max_level:int = 1
@export var current_level:int = 1
@export var icon_path:String
@export var wheather_id:int = 0

var base_cost:int
var base_reward:int


func get_reward() -> void:
    var _reward:Reward = Reward.new()
    @warning_ignore("int_as_enum_without_cast")
    _reward.type = reward_type
    _reward.reward_value = reward_value
    _reward.get_reward()


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
    
    need_cost = base_cost * current_level
    reward_value = base_reward * current_level


func previous_level() -> void:
    if current_level <= 1:
        current_level = 1
        return
    
    current_level -= 1
    
    need_cost = base_cost * current_level
    reward_value = base_reward * current_level
