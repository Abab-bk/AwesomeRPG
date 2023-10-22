class_name FlowerAbility extends Resource

@export var id:int
@export var name:String
@export var desc:String
@export var icon_path:String
@export var cooldown:float
@export var casting_time:float

var ability_container:FlowerAbilityContainer

var is_sub_ability:bool = false
var sub_ability:Array[FlowerAbility] = []

var channeling_time:float
var casting_duration:float

enum STATE {
    CASTING,
    RUNNING,
    COOLDOWN,
    IDLE,
}

var _cooldown_timer:Timer
var _casting_timer:Timer

var current_state:STATE = STATE.IDLE
var actor:Node

func get_cooldown_left() -> float:
    return _cooldown_timer.time_left

func connect_signal() -> void:
    if _casting_timer:
        _casting_timer.timeout.connect(func():)
    _cooldown_timer.timeout.connect(_cooldown_ok)
    current_state = STATE.IDLE
    EventBus.sub_ability_changed.connect(func(_ability_id:int, _sub_ability:Array):
        if not _ability_id == id:
            return
        
        sub_ability = []
        
        for i in _sub_ability:
            var _temp:FlowerAbility = Master.get_ability_by_id(i)
            _temp.is_sub_ability = true
            sub_ability.append(_temp)
            ability_container.add_a_ability(_temp)
        )

func _cooldown_ok() -> void:
    current_state = STATE.IDLE

func _start_casting() -> void:
    if _casting_timer:
        _casting_timer.start()
        current_state = STATE.RUNNING
        await _casting_timer.timeout
    
    current_state = STATE.RUNNING

func active() -> void:
    if current_state == STATE.IDLE:
        # 此时已经冷却完毕
        await _start_casting()
    
    if current_state != STATE.RUNNING:
        return
    
    for i in sub_ability:
        i.active()
    
    ## CUSTOME

func un_active() -> void:
    ## CUSTOME
    current_state = STATE.COOLDOWN
    _cooldown_timer.start()
