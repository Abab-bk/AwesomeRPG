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

var seted_data:CharacterData
var skin_name:String = ""
var data:CharacterData
var output_data:CharacterData

enum STATE {
    PATROL,
    MOVE_TO_PLAYERING,
    ATTACKING,
    DEAD,
    SLEEP
}

#var skin_nodes:Dictionary = {
    #"left_leg": $"Display/Skeleton/bone_004/Left Leg",
    #"right_leg": $"Display/Skeleton/bone_005/Right Leg",
    #"head": $Display/Skeleton/bone_006/bone_007/Head,
    #"face": $"Display/Skeleton/bone_006/bone_007/Face 01",
    #"right_hand": $"Display/Skeleton/bone_006/bone_002/bone_003/Right Hand",
    #"right_arm": $"Display/Skeleton/bone_006/bone_002/Right Arm",
    #"weapon": $Display/Skeleton/bone_006/bone_000/bone_001/Weapon,
    #"left_hand": $"Display/Skeleton/bone_006/bone_000/bone_001/Left Hand",
    #"left_arm": $"Display/Skeleton/bone_006/bone_000/Left Arm",
    #"body": $Display/Skeleton/bone_006/Body
#}

var current_state:STATE = STATE.PATROL

func show_damage_label(value:int, crit:bool) -> void:
    EventBus.show_damage_number.emit(get_global_transform_with_canvas().get_origin(), str(value), crit)
    if $AnimationPlayer:
        $AnimationPlayer.play("Hited")

func _ready() -> void:
    set_skin()
    
    hurt_box_component.hited.connect(func(value:int, crit:bool):
        show_damage_label(value, crit)
        )
    
    atk_range.target_enter_range.connect(func():
        velocity = Vector2.ZERO
        
        if current_state == STATE.DEAD:
            return
        
        turn_to_player()
            
        # 攻击代码
        if character_animation.has_animation("scml/Attacking"):
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
    
    if Master.player.get_level() >= 8:
        _level = Master.player.get_level() - 7
    
    # 设置属性 （每个敌人 ready 都是生成时）
    set_level(_level)

func accept_damage(_value:float) -> void:
    output_data.hp -= _value

func set_data(_data:CharacterData) -> void:
    seted_data = _data

func set_skin() -> void:
    # 设置皮肤
    if skin_name == "" or skin_name == "默认":
        return
    
    $Display.get_node("Skeleton").queue_free()
    var new_node = load("res://Scene/Perfabs/NonPlayCharacter/%s.tscn" % skin_name).instantiate() as OtherEnemy
    $Display.add_child(new_node)
    character_animation = new_node.animation_player
    
    new_node.hitbox_component.buff_manager = buff_manager
    

func turn_to_player() -> void:
    var _dir:Vector2 = to_local(Master.player.global_position).normalized()
        
    if _dir.x > 0:
        # Right
        self.scale.x = 1
    elif  _dir.x < 0:
        self.scale.x = -1

func move_to_player() -> void:
    turn_to_player()
    
    velocity = global_position.\
    direction_to(Master.player.global_position) * output_data.speed
    
    #var steering:Vector2 = (desired_velocity - velocity) * _delta * 2.5
    #velocity += steering
    
    if character_animation:    
        character_animation.play("scml/Walking")

func die() -> void:
    if current_state == STATE.DEAD:
        return
    
    current_state = STATE.DEAD
    
    Master.player.current_state = Master.player.STATE.IDLE
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
        # TODO: get_money
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
    # 如果已经存在，那个尝试在该坐标的上下左右再次判断，循环往复，如果坐标超过最大限制，就改变坐标为原点
    # 最后把新坐标赋值给 _result
    
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
        velocity = Vector2(1, 1)
    
    move_and_slide()
    hp_bar.value = (float(data.hp) / float(data.max_hp)) * 100.0
