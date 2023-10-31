class_name Player extends CharacterBody2D

signal criticaled

# TODO: 优化玩家寻找敌人逻辑

@onready var ability_container:FlowerAbilityContainer = $FlowerAbilityContainer
@onready var flower_buff_manager:FlowerBuffManager = $FlowerBuffManager
#@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var hurt_box_collision:CollisionShape2D = $HurtBoxComponent/CollisionShape2D
@onready var atk_cd_timer:Timer = $AtkCDTimer
#@onready var weapon_component:Node2D = $Sprite2D/Weapons/WeaponComponent
@onready var character_animation_player:AnimationPlayer = %CharacterAnimationPlayer
@onready var hit_box_component:HitBoxComponent = %HitBoxComponent
@onready var atk_range:AtkRangeComponent = $AtkRangeComponent
@onready var vision:VisionComponent = $VisionComponent

@onready var sprites:Dictionary = {
    "weapon": $"Warrior - 01/Skeleton/bone_004/bone_000/bone_001/Weapon"
}

enum STATE {
    IDLE,
    RUNNING,
    ATTACKING,
    DEAD,
}

var current_state:STATE = STATE.IDLE

var data:CharacterData
var target:Vector2 = global_position

var config_skills:Dictionary = {}

var closest_distance:float = 1000000
var closest_enemy:Enemy
var all_enemy:Array

func _ready() -> void:
    Master.player = self
    EventBus.player_dead.connect(relife)
    EventBus.enemy_die.connect(find_closest_enemy)
    EventBus.equipment_up.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
        # 装备装备
        # TODO: 如果 type 是武器或者项链，选择左右手，当前为直接替换
        data.quipments[_type] = _item
        
        var _temp:Array[FlowerBaseBuff] = []
        # 装备装备时，应用装备 Buff
        for i in _item.pre_affixs:
            _temp.append(i.buff)
        
        for i in _item.buf_affix:
            _temp.append(i.buff)
        
        if _item.weapon_type != Const.WEAPONS_TYPE.NULL:
            change_weapons_sprite(load(_item.texture_path))
        
        flower_buff_manager.add_buff_list(_temp)
        
        # 更新 UI
        EventBus.equipment_up_ok.emit(_type, _item))
    
    EventBus.equipment_down.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            data.quipments[_type] = null
            
            var _temp:Array[FlowerBaseBuff] = []
            
            for i in _item.pre_affixs:
                _temp.append(i.buff)
            for i in _item.buf_affix:
                _temp.append(i.buff)
            
            flower_buff_manager.remove_buff_list(_temp)
            
            print("移除装备")
            EventBus.equipment_down_ok.emit(_type, _item))
    
    EventBus.player_ability_activate.connect(func(_ability:FlowerAbility):
        ability_container.active_a_ability(_ability)
        )
    
    EventBus.player_set_a_ability.connect(func(_ability:FlowerAbility,
    _sub_ability:Array):
        if _ability.id in config_skills:
            config_skills[_ability.id].append_array(_sub_ability)
            EventBus.sub_ability_changed.emit(_ability.id, _sub_ability)
        else:
            config_skills[_ability.id] = _sub_ability
            EventBus.sub_ability_changed.emit(_ability.id, _sub_ability)
        
        for i in config_skills.keys():
            ability_container.add_a_ability(_ability)
        
        EventBus.player_ability_change.emit()
        )
    
    EventBus.enemy_die.connect(func(_value):
        get_xp(_value)
        if not closest_enemy:
            find_closest_enemy()
        )
    
    # TODO: 完善存档
    EventBus.save.connect(func():
        SaveSystem.set_var("Player", data)
#        SaveSystem.set_var("Player:Abilitys", ability_container.ability_list)
        )
    
    EventBus.load_save.connect(func():
        print(SaveSystem.get_var("Player"))
#        data.load_save(SaveSystem.get_var("Player"))
#        ability_container.ability_list = SaveSystem.get_var("Player:Abilitys")
        )
    
    flower_buff_manager.compute_ok.connect(func():
        EventBus.player_data_change.emit()
        Master.player_data = flower_buff_manager.output_data
        atk_cd_timer.wait_time = data.atk_speed
        print("计算完成")
        )
#    flower_buff_manager.a_buff_removed
    
    atk_range.target_enter_range.connect(func():
        velocity = Vector2.ZERO
        # 攻击代码
        if current_state == STATE.DEAD:
            return
        
        if global_position != closest_enemy.marker.global_position:
            global_position = closest_enemy.marker.global_position
        
        character_animation_player.play("scml/Attacking")
        current_state = STATE.ATTACKING
        )
    
    vision.target_enter_range.connect(func():
        if current_state == STATE.DEAD:        
            return
        
        var _dir:Vector2 = to_local(closest_enemy.global_position).normalized()
        
        if _dir.x > 0:
            # Right
            self.scale.x = 1
        elif  _dir.x < 0:
            self.scale.x = -1
        
        move_to_enemy()
        )
    
    hit_box_component.criticaled.connect(func(): EventBus.player_criticaled.emit())
    
    data = flower_buff_manager.compute_data as CharacterData
    flower_buff_manager.output_data = data.duplicate(true)
    atk_cd_timer.wait_time = data.atk_speed
    Master.player_data = flower_buff_manager.output_data
    
    compute()
    
    find_closest_enemy()

func rebuild_skills() -> void:
    ability_container.ability_list = []
    
    for i in config_skills:
        var new_ability:FlowerAbility = Master.get_ability_by_id(config_skills[i])
        ability_container.add_a_ability(new_ability)
        for x in config_skills[i]:
            var _sub_ability:FlowerAbility = Master.get_ability_by_id(config_skills[i])
            _sub_ability.is_sub_ability = true
            new_ability.sub_ability.append(_sub_ability)
    
    EventBus.player_ability_change.emit()

func compute() -> void:
    flower_buff_manager.compute()

func move_to_enemy() -> void:
    if not closest_enemy:
        find_closest_enemy()
        return
    
    var _dir:Vector2 = to_local(closest_enemy.global_position).normalized()
    
    if _dir.x > 0:
            # Right
        self.scale.x = 1
    elif  _dir.x < 0:
        self.scale.x = -1
    
    velocity = global_position.\
    direction_to(closest_enemy.marker.global_position) * data.speed
    
    character_animation_player.play("scml/Walking")

func _physics_process(_delta: float) -> void:
    if current_state == STATE.IDLE:
        move_to_enemy()
    
    move_and_slide()

func get_ability_list() -> Array:
    var _list:Array = []
    _list = ability_container.ability_list
    return _list

func get_level() -> int:
    return data.level

func change_weapons_sprite(_sprite:Texture2D) -> void:
    # TODO: 改变武器
    sprites["weapon"].texture = _sprite

# ======= 属性 ========
func up_level() -> void:
    data.level_up()
    data.now_xp = 0
    data.update_next_xp()
    EventBus.player_level_up.emit()

func get_xp(_value:float) -> void:
    data.now_xp += _value
    if data.now_xp >= data.next_level_xp:
        up_level()

# ======= 战斗 ========
func relife() -> void:
    # FIXME: data是资源，不会唯一化
    data.hp = data.max_hp
    data.magic = data.max_magic
    global_position = Master.relife_point.global_position
    character_animation_player.play_backwards("scml/Dying")
    await character_animation_player.animation_finished
    # 设置受击框，避免一直死亡造成内存溢出
    hurt_box_collision.call_deferred("set_disabled", false)
    current_state = STATE.IDLE
    get_tree().paused = false
    find_closest_enemy()

func die() -> void:
    if current_state == STATE.DEAD:
        return
    
    get_tree().paused = true
    
    current_state = STATE.DEAD
    hurt_box_collision.call_deferred("set_disabled", true)
    character_animation_player.play("scml/Dying")
    await character_animation_player.animation_finished
    EventBus.player_dead.emit()

func find_closest_enemy(_temp = 0) -> void:
    all_enemy = get_tree().get_nodes_in_group("Enemy")
    closest_distance = 1000000
    for enemy in all_enemy:
        if not closest_enemy:
            closest_enemy = enemy
        
        var enemy_distance = global_position.distance_to(enemy.global_position)
        
        if enemy_distance < closest_distance:
            closest_distance = enemy_distance
            closest_enemy = enemy
    
    atk_range.target = closest_enemy
    vision.target = closest_enemy
