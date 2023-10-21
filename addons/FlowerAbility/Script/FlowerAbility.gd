class_name FlowerAbility extends Resource

@export var id:int
@export var name:String
@export var desc:String
@export var icon_path:String
@export var cooldown:float
@export var casting_time:float

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

func _cooldown_ok() -> void:
    current_state = STATE.IDLE

func _start_casting() -> void:
    if _casting_timer:
        _casting_timer.start()
        current_state = STATE.RUNNING
        await _casting_timer.timeout
    
    current_state = STATE.RUNNING
    active()

func active() -> void:
    if current_state == STATE.IDLE:
        _start_casting()
        return
    
    if current_state != STATE.RUNNING:
        return
    ## CUSTOME

func un_active() -> void:
    ## CUSTOME
    current_state = STATE.COOLDOWN
    _cooldown_timer.start()
