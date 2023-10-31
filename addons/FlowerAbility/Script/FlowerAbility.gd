class_name FlowerAbility extends Resource

@export var id:int
@export var name:String
@export var desc:String
@export var icon_path:String
@export var cooldown:float
@export var casting_time:float
@export var running_time:float
@export var long:bool = false
@export var global:bool = false
@export var scene:PackedScene
# 存实例化的
var real_scene:AbilityScene

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
var _running_timer:Timer

var current_state:STATE = STATE.IDLE
var actor:Node

func get_cooldown_left() -> float:
    return _cooldown_timer.time_left

func connect_signal() -> void:
    if _casting_timer:
        _casting_timer.timeout.connect(func():)
    if _running_timer:
        _running_timer.timeout.connect(un_active)
    if _cooldown_timer:
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
        print("等待吟唱")
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
    
    # HACK: 待优化 COC
    # Tags: 在这里修改特殊技能（暴击时释放等）
    if id in Master.SPECIAL_ABILITYS_ID:
        real_scene = scene.instantiate() as AbilityScene
        real_scene.actor = actor
        real_scene.ability_data = self
        actor.call_deferred("add_child", real_scene)
        return
    
    if global:
        real_scene = scene.instantiate() as AbilityScene
        real_scene.actor = actor
        real_scene.ability_data = self
        Master.world.call_deferred("add_child", real_scene)
#        Master.world.add_child(real_scene)
    else:
        real_scene = scene.instantiate() as AbilityScene
        real_scene.actor = actor
        real_scene.ability_data = self
        actor.call_deferred("add_child", real_scene)
    
    _running_timer.start()
    
    for i in sub_ability:
        i.active()
    
    ## CUSTOME

func active_sub_abilitys() -> void:
    print("激活子技能")
    for i in sub_ability:
        print("激活：", i.name)
        i.active()

func del_self() -> void:
    if real_scene:
        real_scene.timeout()
    
    var _container:FlowerAbilityContainer = Master.player.ability_container
    
    for i in sub_ability:
        _container.remove_a_ability(i)
    
    _container.remove_a_ability(self)
    Master.player.config_skills.erase(self.id)

func un_active() -> void:
    ## CUSTOME
    if real_scene != null:
        print("卸载real_scene，主要是为了被动技能（COC）")
        real_scene.timeout()
    
    current_state = STATE.COOLDOWN
    
    if _cooldown_timer:
        _cooldown_timer.start()
