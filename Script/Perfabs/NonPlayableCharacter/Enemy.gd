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

var dead:bool = false
var data:CharacterData

enum STATE {
    PATROL,
    MOVE_TO_PLAYERING,
    ATTACKING,
}

var current_state:STATE = STATE.PATROL

func _ready() -> void:
    hurt_box_component.hited.connect(func(value:int):
        EventBus.show_damage_number.emit(get_global_transform_with_canvas().get_origin(), str(value))
        )
    
    atk_range.target_enter_range.connect(func():
        velocity = Vector2.ZERO
        # 攻击代码
        
        character_animation.play("scml/Attacking")
        current_state = STATE.ATTACKING
        )
    
    vision_component.target_enter_range.connect(func():
        look_at(Master.player.global_position)
        move_to_player()
        )
    
    atk_range.target = Master.player
    vision_component.target = Master.player
    
    data = buff_manager.compute_data as CharacterData
    # 设置属性 （每个敌人 ready 都是生成时）
    var _level:int = 1
    
    atk_cd_timer.wait_time = data.atk_speed
    
    if Master.player.get_level() >= 5:
        _level = Master.player.get_level() - 3
    
    set_level(_level)
    
    buff_manager.compute()

func move_to_player() -> void:
    velocity = global_position.\
    direction_to(Master.player.global_position) * data.speed
    character_animation.play("scml/Walking")

func die() -> void:
    if dead:
        return
    dead = true
    
    # 获得经验
    EventBus.enemy_die.emit(data.level * 10)
    
    # TODO: 修改敌人掉落金币
    Master.coins += 10
    
    var _drop_item:InventoryItem = item_generator.gen_a_item()
    EventBus.new_drop_item.emit(_drop_item, get_global_transform_with_canvas().get_origin())
    
    character_animation.play("scml/Dying")
    await character_animation.animation_finished
    
    queue_free()

func set_level(_value:int) -> void:
    data.level = _value
    data.set_property_from_level()

func _physics_process(_delta:float) -> void:
    if current_state == STATE.PATROL:
        move_to_player()
    
    move_and_slide()
    hp_bar.value = (float(data.hp) / float(data.max_hp)) * 100.0
