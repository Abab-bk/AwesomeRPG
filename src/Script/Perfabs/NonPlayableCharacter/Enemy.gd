class_name Enemy
extends CharacterBody2D

signal dead

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var item_generator:ItemGenerator = $ItemGenerator as ItemGenerator
@onready var hp_bar:ProgressBar = %HpBar
@onready var hurt_box_component:HurtBoxComponent = $HurtBoxComponent
@onready var atk_range:AtkRangeComponent = $AtkRange
@onready var vision_component:VisionComponent = $VisionComponent
#@onready var weapons:Node2D = %Weapons
@onready var atk_cd_timer:Timer = $AtkCDTimer
@onready var character_animation:AnimationPlayer = $Display/Skeleton/CharacterAnimation
@onready var marker:Marker2D = $Marker2D

@onready var navigation_agent_2d:NavigationAgent2D = %NavigationAgent2D
@onready var navigation_timer:Timer = %NavigationTimer

@export var range_attack:bool = false

var range_bullet_spwan_point:Marker2D

var seted_data:CharacterData
var skin_name:String = ""
var data:CharacterData
var output_data:CharacterData

var is_boss:bool = false

enum STATE {
    PATROL,
    MOVE_TO_PLAYERING,
    ATTACKING,
    ATK_COOLDOWN,
    DEAD,
    SLEEP,
    NOTHING,
}

var current_state:STATE = STATE.PATROL


func move_camera_to_self_position() -> void:
    current_state = STATE.NOTHING
    character_animation.play("scml/Idle")
    velocity = Vector2.ZERO
    EventBus.move_camera_to.emit(global_position)
    await get_tree().create_timer(2.0).timeout
    current_state = STATE.PATROL


func show_damage_label(value:int, crit:bool) -> void:
    EventBus.show_damage_number.emit(get_global_transform_with_canvas().get_origin(), str(value), crit)
    if $AnimationPlayer:
        $AnimationPlayer.play("Hited")


func _ready() -> void:
    set_skin()

    hurt_box_component.hited.connect(func(value:int, crit:bool):
        show_damage_label(value, crit)
        )
    
    atk_range.target_enter_range.connect(func():current_state = STATE.ATTACKING)
    atk_range.target_exited_range.connect(func():current_state = STATE.PATROL)
    
    atk_cd_timer.timeout.connect(func():
        if current_state == STATE.ATK_COOLDOWN:
            current_state = STATE.ATTACKING
        )
    
    navigation_timer.timeout.connect(func():
        navigation_agent_2d.target_position = Master.player.global_position
        )
    
    vision_component.target_enter_range.connect(func():
        turn_to_player()
        )
    
    atk_range.target = Master.player
    vision_component.target = Master.player
    
    buff_manager.compute_ok.connect(func():
        data = buff_manager.compute_data as CharacterData
        output_data = buff_manager.output_data as CharacterData
        $HealthComponent.data = output_data
        
        if output_data.is_connected("hp_is_zero", die):
            return
        output_data.hp_is_zero.connect(die)
        )
    
    EventBus.player_dead.connect(func():
        current_state = STATE.SLEEP
        )
    EventBus.player_relife.connect(func():
        current_state = STATE.PATROL
        )
    
    var _level:int = 1
    
    if seted_data:
        buff_manager.compute_data = seted_data
    
    buff_manager.compute()
    
    atk_cd_timer.wait_time = output_data.atk_speed
    set_vision_range(output_data.vision)
    set_atk_range_range(output_data.atk_range)
    
    if Master.player.get_level() >= 8:
        _level = Master.player.get_level() - 7
    if is_boss:
        _level += 2
    
    # 给敌人穿装备
    var _count:int = min(6, buff_manager.compute_data.level)
    for _i in _count:
        buff_manager.add_buff(Master.get_random_affix().buff)
    
    # 设置属性 （每个敌人 ready 都是生成时）
    set_level(_level)
    
    if is_boss:
        move_camera_to_self_position()



func set_vision_range(_range:float) -> void:
    $VisionComponent/CollisionShape2D.shape.radius = _range


func set_atk_range_range(_range:float) -> void:
    $AtkRange/CollisionShape2D.shape.radius = _range    


func accept_damage(_value:float) -> void:
    output_data.hp -= _value


func set_data(_data:CharacterData, _is_boss:bool = false) -> void:
    is_boss = _is_boss
    seted_data = _data


func attack() -> void:
    atk_cd_timer.start()
    velocity = Vector2.ZERO
    
    if current_state == STATE.DEAD:
        return
    
    turn_to_player()
    
    # 攻击代码
    if not range_attack:
        if character_animation.has_animation("scml/Attacking"):
            character_animation.play("scml/Attacking")
    else:
        if character_animation.has_animation("scml/Shooting"):
            character_animation.play("scml/Shooting")
            spawn_a_bullet()
    
    current_state = STATE.ATK_COOLDOWN


func spawn_a_bullet() -> void:
    var _data:CharacterData = output_data.duplicate(true)
    _data.speed = 1000
    var _bullet:BaseBullet = Builder.build_a_base_bullet(_data, false) as BaseBullet
    range_bullet_spwan_point.add_child(_bullet)
    _bullet.global_position = range_bullet_spwan_point.global_position
    _bullet.update_velocity()


func set_skin() -> void:
    # 设置皮肤
    if skin_name == "" or skin_name == "默认":
        return
    
    $Display.get_node("Skeleton").queue_free()
    var new_node = load("res://Scene/Perfabs/NonPlayCharacter/%s.tscn" % skin_name).instantiate() as OtherEnemy
    $Display.add_child(new_node)
    character_animation = new_node.animation_player
    range_attack = new_node.range_attack
    
    if not new_node.range_attack:
        new_node.hitbox_component.buff_manager = buff_manager
    else:
        range_bullet_spwan_point = new_node.bullet_spawn_point


func turn_to_player() -> void:
    var _dir:Vector2 = to_local(Master.player.global_position).normalized()
        
    if _dir.x > 0:
        # Right
        self.scale.x = 1
    elif  _dir.x < 0:
        self.scale.x = -1


func move_to_player() -> void:
    turn_to_player()
    
    if not navigation_agent_2d.is_navigation_finished():
        #var _direction:Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
        var _direction:Vector2 = global_position.direction_to(navigation_agent_2d.get_next_path_position())
        velocity = _direction * output_data.speed
    
    #velocity = global_position.\
    #direction_to(Master.player.global_position) * output_data.speed
    
    if character_animation:    
        character_animation.play("scml/Walking")


func die() -> void:
    if current_state == STATE.DEAD:
        return
    
    current_state = STATE.DEAD
    
    # Master.player.current_state = Master.player.STATE.IDLE
    # 获得经验
    #EventBus.enemy_die.emit(data.level * data.level * data.level * 3 * (1 + Master.fly_count * 0.1))
    #EventBus.enemy_die.emit(((Master.player_data.level * 3) + 15) * (1 + Master.fly_count * 0.1))
    #EventBus.enemy_die.emit((data.level * 3) * (1 + Master.fly_count * 0.1))
    var _get_xp:float = (3 * data.level * 1.5) * (1 + Master.fly_count * 0.1)
    EventBus.enemy_die.emit(_get_xp)
    # TODO: 修改敌人掉落金币
    randomize()
    Master.coins += data.level * randi_range(0, 5)
    
    dead.emit()
    
    randomize()
    # 随机掉落装备
    if randf_range(0.0, 100.0) <= 16.0:
        var _drop_item:InventoryItem = item_generator.gen_a_item()
        EventBus.new_drop_item.emit(_drop_item, get_drop_item_position())
    if randf_range(0.0, 100.0) <= 10:
        # 爆金币了
        var _new_money_key = Master.moneys.keys().pick_random()
        var _random_value:int = randi_range(1, 10)
        EventBus.get_money.emit(_new_money_key, _random_value)
    
    var _drop_potion:bool = [true, false].pick_random()
    if _drop_potion:
        EventBus.player_get_healing_potion.emit(["hp", "mp"].pick_random(), 1)
    
    queue_free()


func get_drop_item_position() -> Vector2:
    var _result:Vector2 = get_global_transform_with_canvas().get_origin()
    
    # 判断 _result 是否已经存在drop_item
    while is_position_occupied(_result):
        _result += Vector2(randf_range(-20.0, 20.0), randf_range(-20.0, 20.0)) 
        
        if _result.x > 500 || _result.y > 500:
            _result = _result
            break
    
    return _result


func is_position_occupied(_position: Vector2) -> bool:
    for occupied in Master.occupied_positions:
        if _position.distance_to(occupied) < 20:
            return true
    
    return false


func set_level(_value:int) -> void:
    data.level = _value
    data.set_property_from_level()
    buff_manager.compute()


func _physics_process(_delta:float) -> void:
    if current_state == STATE.PATROL:
        move_to_player()
    
    if current_state == STATE.SLEEP:
        velocity = Vector2.ZERO
    
    if current_state == STATE.ATTACKING:
        attack()
    
    move_and_slide()
    hp_bar.value = (float(data.hp) / float(data.max_hp)) * 100.0
