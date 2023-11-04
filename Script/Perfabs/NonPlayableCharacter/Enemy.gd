class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var item_generator:ItemGenerator = $ItemGenerator
@onready var hp_bar:ProgressBar = %HpBar
@onready var hurt_box_component:HurtBoxComponent = $HurtBoxComponent
@onready var atk_range:AtkRangeComponent = $AtkRange
@onready var vision_component:VisionComponent = $VisionComponent
#@onready var weapons:Node2D = %Weapons
@onready var atk_cd_timer:Timer = $AtkCDTimer
@onready var character_animation:AnimationPlayer = %CharacterAnimation
@onready var marker:Marker2D = $Marker2D

var data:CharacterData
var output_data:CharacterData

enum STATE {
    PATROL,
    MOVE_TO_PLAYERING,
    ATTACKING,
    DEAD,
}

var current_state:STATE = STATE.PATROL

func _ready() -> void:
    hurt_box_component.hited.connect(func(value:int):
        EventBus.show_damage_number.emit(get_global_transform_with_canvas().get_origin(), str(value))
        $AnimationPlayer.play("Hited")
        )
    
    atk_range.target_enter_range.connect(func():
        velocity = Vector2.ZERO
        
        if current_state == STATE.DEAD:
            return
        
        turn_to_player()
            
        # 攻击代码
        character_animation.play("scml/Attacking")
        current_state = STATE.ATTACKING
        
        #if global_position != Master.player.marker.global_position:
            #global_position = Master.player.marker.global_position
        
        )
    
    atk_range.target_exited_range.connect(func():
        current_state = STATE.PATROL
        )
    
    vision_component.target_enter_range.connect(func():
        turn_to_player()
        )
    
    atk_range.target = Master.player
    vision_component.target = Master.player
    
    buff_manager.compute_ok.connect(func():
        print("计算完成")
        data = buff_manager.compute_data as CharacterData
        output_data = buff_manager.output_data as CharacterData
        $HealthComponent.data = output_data
        
        if output_data.is_connected("hp_is_zero", die):
            return
        output_data.hp_is_zero.connect(die)
        )
    
    var _level:int = 1
    
    buff_manager.compute()
    
    atk_cd_timer.wait_time = data.atk_speed
    
    if Master.player.get_level() >= 5:
        _level = Master.player.get_level() - 3
    
    # 设置属性 （每个敌人 ready 都是生成时）
    set_level(_level)

func turn_to_player() -> void:
    var _dir:Vector2 = to_local(Master.player.global_position).normalized()
        
    if _dir.x > 0:
        # Right
        self.scale.x = 1
    elif  _dir.x < 0:
        self.scale.x = -1

func move_to_player(_delta:float) -> void:
    turn_to_player()
    
    var dir:Vector2 = global_position.\
    direction_to(Master.player.global_position)
    var desired_velocity:Vector2 = dir * data.speed
    
    var steering:Vector2 = (desired_velocity - velocity) * _delta * 2.5
    
    velocity += steering
    
    character_animation.play("scml/Walking")

func die() -> void:
    if current_state == STATE.DEAD:
        return
    
    current_state = STATE.DEAD
    
    Master.player.current_state = Master.player.STATE.IDLE
    # 获得经验
    EventBus.enemy_die.emit(data.level * 10)
    # TODO: 修改敌人掉落金币
    Master.coins += 10
    
    # 随机掉落装备
    if randi_range(0, 100) >= 50:
        var _drop_item:InventoryItem = item_generator.gen_a_item()
        EventBus.new_drop_item.emit(_drop_item, get_global_transform_with_canvas().get_origin())
    
    queue_free()

func set_level(_value:int) -> void:
    data.level = _value
    data.set_property_from_level()
    buff_manager.compute()

func _physics_process(_delta:float) -> void:
    if current_state == STATE.PATROL:
        move_to_player(_delta)
    
    move_and_slide()
    hp_bar.value = (float(data.hp) / float(data.max_hp)) * 100.0
