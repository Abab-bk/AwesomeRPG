class_name FlowerAbilityContainer extends Node

@export var ability_list:Array[FlowerAbility]
@export var actor:Node

func _ready() -> void:
    for i in ability_list:
        i.actor = actor
        
        var _cool_down_timer:Timer = _build_a_timer(i.cooldown)
        add_child(_cool_down_timer)
        
        if not i.casting_time <= 0.0:
            var _casting_timer:Timer = _build_a_timer(i.casting_time)
            add_child(_casting_timer)
            i._casting_timer = _casting_timer
        
        i._cooldown_timer = _cool_down_timer
        i.connect_signal()

func _build_a_timer(_time:float) -> Timer:
    var _timer:Timer = Timer.new()
    _timer.wait_time = _time
    _timer.one_shot = true
    _timer.autostart = false
    return _timer

func active_a_ability(_ability:FlowerAbility) -> void:
    _ability.active()

func active_a_ability_by_id(_id:String) -> void:
    for _ability in ability_list:
        if _ability.id == _id:
            _ability.active()

func active_a_ability_by_name(_name:String) -> void:
    for _ability in ability_list:
        if _ability.name == _name:
            _ability.active()

func remove_a_ability(_ability:FlowerAbility) -> void:
    ability_list.erase(_ability)

func remove_a_ability_by_id(_id:String) -> void:
    for _ability in ability_list:
        if _ability.id == _id:
            ability_list.erase(_ability)

func remove_a_ability_by_name(_name:String) -> void:
    for _ability in ability_list:
        if _ability.name == _name:
            ability_list.erase(_ability)
