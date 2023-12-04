class_name Friend extends CharacterBody2D

const MAX_DISTANCE_FROM_PLAYER:float = 600.0
const MIN_DISTANCE_FROM_PLAUER:float = 200.0

@export var buff_manager:FlowerBuffManager

@onready var health_component:HealthComponent = $HealthComponent
@onready var vision_component:VisionComponent = $VisionComponent
@onready var atk_range:AtkRangeComponent = $AtkRange
@onready var hurt_box_component:HurtBoxComponent = $HurtBoxComponent
@onready var ray_cast:RayCast2D = $RayCast2D

@onready var hurt_box_shape:CollisionShape2D = $HurtBoxComponent/CollisionShape2D

@onready var atk_cd_timer:Timer = $AtkCDTimer

@onready var character_animation:AnimationPlayer = $Display/Skeleton/CharacterAnimation

@export var info_data:FriendData
@export var skin_name:String = ""

enum STATE {
    MOVE_TO_PLAYERING,
    MOVE_TO_ENEMYING,
    ATTACKING,
    DEAD,
    IDLE
}

var current_state:STATE = STATE.IDLE

var target_player_point:Marker2D

var compute_data:CharacterData
var output_data:CharacterData

var closest_enemy:Enemy

var closest_distance:float = 1000000

var all_enemy:Array

var seted_data:CharacterData

func _ready() -> void:
    set_skin()

    atk_range.target_enter_range.connect(func():
        velocity = Vector2.ZERO
        
        if current_state == STATE.DEAD:
            return
        
        turn_to_enemy()
        
        # 攻击代码
        if character_animation.has_animation("scml/Attacking"):
            character_animation.play("scml/Attacking")
        current_state = STATE.ATTACKING
        )

    atk_range.target_exited_range.connect(func():
        current_state = STATE.IDLE
        )
    
    vision_component.target_enter_range.connect(func():
        turn_to_enemy()
        )
    
    buff_manager.compute_ok.connect(func():
        compute_data = buff_manager.compute_data as CharacterData
        output_data = buff_manager.output_data as CharacterData
        $HealthComponent.data = output_data
        
        if output_data.is_connected("hp_is_zero", die):
            return
        output_data.hp_is_zero.connect(die)
        )
    
    EventBus.kill_all_friend.connect(func():
        queue_free()
        )
    
    if seted_data:
        buff_manager.compute_data = seted_data
    
    buff_manager.compute()
    
    atk_cd_timer.wait_time = output_data.atk_speed


func _physics_process(_delta:float) -> void:
    if current_state == STATE.IDLE:
        move_to_enemy()
    
    if current_state == STATE.ATTACKING:
        if not closest_enemy:
            find_closest_enemy()
    
    if current_state == STATE.MOVE_TO_PLAYERING:
        move_to_player()
    
    if global_position.distance_to(target_player_point.global_position) >= MAX_DISTANCE_FROM_PLAYER:
        # 跟随玩家
        current_state = STATE.MOVE_TO_PLAYERING
    
    move_and_slide()


func move_to_player() -> void:
    var direction = (target_player_point.global_position - global_position).normalized()
    velocity = direction * output_data.speed
    
    turn_to_player()
    
    if global_position.distance_to(target_player_point.global_position) <= MIN_DISTANCE_FROM_PLAUER:
        current_state = STATE.IDLE


func set_data(_data:CharacterData) -> void:
    seted_data = _data


func attack() -> void:
    velocity = Vector2.ZERO
    
    # 攻击代码
    if current_state == STATE.DEAD:
        return
    
    if global_position != closest_enemy.marker.global_position:
        global_position = closest_enemy.marker.global_position
    
    turn_to_enemy()
    
    character_animation.play("scml/Attacking")
    current_state = STATE.ATTACKING


func move_to_enemy() -> void:
    if not closest_enemy:
        find_closest_enemy()
        return
    
    turn_to_enemy()
    
    if ray_cast.is_colliding():
        attack()
        closest_enemy = ray_cast.get_collider()
        return
    
    velocity = global_position.\
    direction_to(closest_enemy.marker.global_position) * output_data.speed
    
    character_animation.play("scml/Walking")


func find_closest_enemy() -> void:
    if ray_cast.is_colliding():
        closest_enemy = ray_cast.get_collider().owner
        attack()
        turn_to_enemy()
        current_state = STATE.IDLE
        return
    
    all_enemy = get_tree().get_nodes_in_group("Enemy")
    closest_distance = 1000000
    
    var _enemys_distance:Array = []
    
    for enemy in all_enemy:
        _enemys_distance.append([global_position.distance_to(enemy.global_position), enemy])
    
    _enemys_distance.sort_custom(func(_a, _b):
        if _a[0] < _b[0]:
            return true
        return false
        )
    closest_enemy = _enemys_distance[0][1]
    closest_distance = _enemys_distance[0][0]
    
    #for enemy in all_enemy:
        #if not closest_enemy:
            #closest_enemy = enemy
        #
        #var enemy_distance = global_position.distance_to(enemy.global_position)
        #
        #if enemy_distance < closest_distance:
            #closest_distance = enemy_distance
            #closest_enemy = enemy
    
    atk_range.target = closest_enemy
    vision_component.target = closest_enemy
    
    current_state = STATE.IDLE


func relife() -> void:
    compute_data.hp = compute_data.max_hp
    output_data.hp = output_data.max_hp
    buff_manager.compute()
    # FIXME: 需要使用call_defereed，寻找变通方法
    #hurt_box_shape.disabled = false
    hurt_box_shape.call_deferred("set_disabled", false)
    current_state = STATE.IDLE


func die() -> void:
    current_state = STATE.DEAD
    hurt_box_shape.call_deferred("set_disabled", true)
    #hurt_box_shape.disabled = true
    character_animation.play("scml/Dying")
    await character_animation.animation_finished
    relife()


func turn_to_player() -> void:
    var _dir:Vector2 = to_local(Master.player.global_position).normalized()
        
    if _dir.x > 0:
        # Right
        self.scale.x = 1
    elif  _dir.x < 0:
        self.scale.x = -1


func turn_to_enemy() -> void:
    var _dir:Vector2 = to_local(closest_enemy.global_position).normalized()
    
    if _dir.x > 0:
        # Right
        self.scale.x = 1
    elif  _dir.x < 0:
        self.scale.x = -1


func set_skin() -> void:
    # 设置皮肤
    if skin_name == "" or skin_name == "默认":
        return
    
    $Display.get_node("Skeleton").queue_free()
    var new_node = load("res://Scene/Perfabs/PlayabelCharacter/%s.tscn" % skin_name).instantiate() as FriendSkin
    $Display.add_child(new_node)
    
    character_animation = new_node.animation_player
    
    current_state = STATE.IDLE
    
    new_node.hitbox_component.buff_manager = buff_manager
