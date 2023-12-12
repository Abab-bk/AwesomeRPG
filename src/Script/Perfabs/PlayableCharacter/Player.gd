class_name Player extends CharacterBody2D

signal criticaled

@onready var ability_container:FlowerAbilityContainer = $FlowerAbilityContainer
@onready var flower_buff_manager:FlowerBuffManager = $FlowerBuffManager as FlowerBuffManager
#@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var hurt_box_collision:CollisionShape2D = $HurtBoxComponent/CollisionShape2D
@onready var hurt_box_component:HurtBoxComponent = $HurtBoxComponent
@onready var atk_cd_timer:Timer = $AtkCDTimer
#@onready var weapon_component:Node2D = $Sprite2D/Weapons/WeaponComponent
@onready var character_animation_player:AnimationPlayer = %CharacterAnimationPlayer
@onready var hit_box_component:HitBoxComponent = %HitBoxComponent
@onready var atk_range:AtkRangeComponent = $AtkRangeComponent
@onready var vision:VisionComponent = $VisionComponent as VisionComponent
@onready var ray_cast:RayCast2D = $RayCast2D
@onready var marker:Marker2D = $Marker2D
@onready var ranged_weapon:RangedWeaponComponent = $RangedWeaponComponent

@onready var sprites:Dictionary = {
    "weapon": $"Warrior - 01/Skeleton/bone_004/bone_000/bone_001/Weapon",
    "head": $"Warrior - 01/Skeleton/bone_004/bone_005/Head",
    "body": $"Warrior - 01/Skeleton/bone_004/Body"
}

@onready var friends_pos:Array[Marker2D] = [$FriendsPos/Pos1, $FriendsPos/Pos2, $FriendsPos/Pos3]
@onready var navigation_agent_2d:NavigationAgent2D = %NavigationAgent2D

enum STATE { # IDLE -> FINDING -> MOVE_TO_ENEMYING -> ATTACKING -> FINDING
    IDLE, # 初始状态
    ATTACKING, # 攻击中
    FINDING, # 寻找敌人中
    MOVE_TO_ENEMYING, # 向敌人中状态
    DEAD, # 死亡
    INITING,
}

var current_state:STATE = STATE.INITING

@export var compute_data:CharacterData
@export var output_data:CharacterData

var target:Vector2 = global_position

var config_skills:Dictionary = {}:
    set(v):
        config_skills = v
        FlowerSaver.set_data("config_skills", config_skills)

var closest_distance:float = 1000000
var closest_enemy:Enemy
var all_enemy:Array


func _ready() -> void:
    
    Master.player = self
    #EventBus.player_dead.connect(relife)
    EventBus.enemy_die.connect(find_closest_enemy)
    EventBus.equipment_up.connect(euipment_up)
    
    EventBus.equipment_down.connect(equipment_down)
    
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
    
    flower_buff_manager.compute_ok.connect(func():
        Master.player_data = flower_buff_manager.compute_data
        Master.player_output_data = flower_buff_manager.output_data
        
        compute_data = flower_buff_manager.compute_data as CharacterData
        output_data = flower_buff_manager.output_data as CharacterData
        
        ray_cast.target_position.x = output_data.atk_range
        
        atk_cd_timer.wait_time = output_data.atk_speed
        
        EventBus.player_data_change.emit()
        EventBus.update_ui.emit()
        
        if not output_data.is_connected("hp_is_zero", die):
            output_data.hp_is_zero.connect(die)
        )
    
    EventBus.save.connect(func():
        FlowerSaver.set_data("player_compute_data", flower_buff_manager.compute_data)
        FlowerSaver.set_data("player_output_data", flower_buff_manager.output_data)
        FlowerSaver.set_data("player_buff_list", flower_buff_manager.buff_list)
        FlowerSaver.set_data("config_skills", config_skills)
        #print("玩家存档：", flower_buff_manager.output_data.level)
        )
    
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("flyed_just_now"):
            if FlowerSaver.get_data("flyed_just_now") == true:
                Tracer.info("玩家飞升读档")
                flower_buff_manager.compute_data = get_origin_player_data().duplicate(true)
                flower_buff_manager.output_data = get_origin_player_data().duplicate(true)
                compute_data = flower_buff_manager.compute_data as CharacterData
                output_data = flower_buff_manager.output_data as CharacterData
                # print("玩家等级：", output_data.level) # 读出来就是玩家等级2
                
                for i in Master.flyed_obtain_buffs:
                    compute_data[i[0]] += i[1]
                
                Master.player_data = compute_data
                Master.player_output_data = output_data
                compute()
                
                reset_player_hp_and_magic()
                
                return
        
        Tracer.info("玩家常规读档")
        
        compute_data = FlowerSaver.get_data("player_compute_data")
        output_data = FlowerSaver.get_data("player_output_data")
        
        flower_buff_manager.compute_data = compute_data
        flower_buff_manager.output_data = output_data
        flower_buff_manager.add_buff_list(FlowerSaver.get_data("player_buff_list"))
        
        Master.player_output_data = flower_buff_manager.output_data
        
        if FlowerSaver.has_key("config_skills"):
            config_skills = FlowerSaver.get_data("config_skills")
        Master.get_offline_reward()
        
        #compute()
        
        update_equipment_textures()
        
        # 更新 UI 信号
        EventBus.player_data_change.emit()
        rebuild_skills()
        reset_player_hp_and_magic()
        #compute_all_euipment()
        )
    
    EventBus.flyed.connect(func():
        Master.player_inventory.remove_all_item()
        flower_buff_manager.compute_data = load("res://Assets/Resources/Datas/Characters/Player.tres")
        flower_buff_manager.output_data = load("res://Assets/Resources/Datas/Characters/Player.tres")
        )
        
    atk_range.target_enter_range.connect(func():
        attack()
        )
    
    vision.target_exited_range.connect(func():
        ranged_weapon.should_atk = false
        )
    
    vision.target_enter_range.connect(func():
        if current_state == STATE.DEAD:        
            return
        
        ranged_weapon.should_atk = true
        
        current_state = STATE.MOVE_TO_ENEMYING        
        turn_to_closest_enemy()
        #move_to_enemy()
        )
    
    hurt_box_component.hited.connect(func(_v, _v1):
        if current_state == STATE.DEAD:
            return
        $AnimationPlayer.play("oh_hit")
        EventBus.update_ui.emit()
        )
    
    atk_cd_timer.timeout.connect(ranged_attack)
    
    hit_box_component.criticaled.connect(func(): EventBus.player_criticaled.emit())
    
    compute_data = flower_buff_manager.compute_data as CharacterData
    output_data = flower_buff_manager.output_data as CharacterData
    
    flower_buff_manager.output_data = compute_data.duplicate(true)
    atk_cd_timer.wait_time = compute_data.atk_speed
    
    output_data.hp_is_zero.connect(die)
    
    compute()
    
    Master.player_output_data = flower_buff_manager.output_data
    Master.player_data = flower_buff_manager.compute_data
    Master.player_camera = $Camera2D
    
    #find_closest_enemy()
    
    atk_cd_timer.start()
    
    reset_player_hp_and_magic()
    
    EventBus.update_ui.emit()
    
    compute()
    
    await get_tree().process_frame
    current_state = STATE.IDLE


func reset_player_hp_and_magic() -> void:
    flower_buff_manager.compute_data.reset_hp_and_magic()
    flower_buff_manager.output_data.reset_hp_and_magic()
    
    compute_data.reset_hp_and_magic()
    output_data.reset_hp_and_magic()
    
    EventBus.update_ui.emit()


func get_origin_player_data() -> CharacterData:
    return load("res://Assets/Resources/Datas/Characters/Player.tres")


func euipment_up(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
    # 装备装备
    compute_data.quipments[_type] = _item
    
    var _temp:Array[FlowerBaseBuff] = []
    # 装备装备时，应用装备 Buff
    var _main_buff:FlowerBaseBuff = _item.main_buffs.buff
    _temp.append(_main_buff)
    
    for i in _item.pre_affixs:
        _temp.append(i.buff)
        #print(i.buff.get_origin_compute_datas())
    
    for i in _item.buf_affix:
        _temp.append(i.buff)
        #print(i.buff.get_origin_compute_datas())
    
    match _item.type:
        Const.EQUIPMENT_TYPE.头盔:
            change_head_sprite(load(_item.texture_path))
        Const.EQUIPMENT_TYPE.武器:
            change_weapons_sprite(load(_item.texture_path))
        Const.EQUIPMENT_TYPE.胸甲:
            change_body_sprite(load(_item.texture_path))
    
    var _info_1 = get_buffs_info(_temp)    
    
    flower_buff_manager.add_buff_list(_temp)

    var _info_2 = get_buffs_info(_temp)    
    
    var _final_info = merge_two_dic(_info_1, _info_2)
    
    EventBus.show_animation.emit("PropertyContrast", _final_info)
    
    # 移出背包
    EventBus.remove_item.emit(_item)
    
    # 更新 UI
    EventBus.equipment_up_ok.emit(_type, _item)


func equipment_down(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem, _add_item:bool) -> void:
    var _inentorry = Master.player_inventory as Inventory
    if _inentorry.items.size() >= _inentorry.size:
        EventBus.new_tips.emit("背包已满")
        return
    
    compute_data.quipments[_type] = null
    
    var _temp:Array[FlowerBaseBuff] = []
    
    var _main_buff:FlowerBaseBuff = _item.main_buffs.buff
    
    _temp.append(_main_buff)
    
    for i in _item.pre_affixs:
        _temp.append(i.buff)
    for i in _item.buf_affix:
        _temp.append(i.buff)
    
    flower_buff_manager.remove_buff_list(_temp)
    
    print("移除装备")
    
    match _item.type:
        Const.EQUIPMENT_TYPE.头盔:
            change_head_sprite(load("res://Assets/Characters/Warrior/Head.png"))
        Const.EQUIPMENT_TYPE.武器:
            change_weapons_sprite(load("res://Assets/Characters/Warrior/Weapon.png"))
        Const.EQUIPMENT_TYPE.胸甲:
            change_body_sprite(load("res://Assets/Characters/Warrior/Body.png"))
    
    EventBus.equipment_down_ok.emit(_type, _item, _add_item)


func merge_two_dic(_dic_1:Dictionary, _dic_2:Dictionary) -> Dictionary:
    var _result:Dictionary = {}
    
    #Tracer.info("合并字典：%s, %s" % [_dic_1, _dic_2])
    
    # 获取所有键的集合
    var _keys = _dic_1.keys() + _dic_2.keys()

    for key in _keys:
        # 获取字典中的值，如果键不存在则返回一个默认值（这里是空数组 []）
        var values_1 = _dic_1.get(key, [])
        var values_2 = _dic_2.get(key, [])
        
        # 合并两个数组
        var merged_values = values_1 + values_2
    
        # 将合并后的值添加到新的字典中
        _result[key] = merged_values
    
    return _result


func get_buffs_info(_buff_list:Array[FlowerBaseBuff]) -> Dictionary:
    var _result:Dictionary = {}
    
    for i in _buff_list:
        # 拿到key
        for j in i.compute_values:
            _result[j.target_property] = [output_data[j.target_property]]
    
    return _result


func compute_all_euipment() -> void:
    # 装备装备
    for equipment_index in compute_data.quipments.keys():
        print("计算所有装备：%s" % str(equipment_index))
        var _item = compute_data.quipments[equipment_index]
        
        var _temp:Array[FlowerBaseBuff] = []
        # 装备装备时，应用装备 Buff
        _temp.append(_item.main_buffs.buff)
        
        for i in _item.pre_affixs:
            _temp.append(i.buff)
    
        for i in _item.buf_affix:
            _temp.append(i.buff)
        
        flower_buff_manager.add_buff_list(_temp)
        # 更新 UI
        #EventBus.equipment_up_ok.emit(_item.type, _item)


func update_equipment_textures() -> void:
    var _data:Dictionary = {}
    
    # FIXME: compute_data.quipments[equipment_index]里面是null，应该是飞升后导致的
    
    #Tracer.info("compute_data.quipments: %s" % str(compute_data.quipments))
    
    for equipment_index in compute_data.quipments.keys():
        var _item = compute_data.quipments[equipment_index]
        
        if not _item:
            continue
        
        match _item.type:
            Const.EQUIPMENT_TYPE.头盔:
                change_head_sprite(load(_item.texture_path))
                _data["head"] = _item.texture_path
            Const.EQUIPMENT_TYPE.武器:
                change_weapons_sprite(load(_item.texture_path))
                _data["weapon"] = _item.texture_path
            Const.EQUIPMENT_TYPE.胸甲:
                change_body_sprite(load(_item.texture_path))
                _data["body"] = _item.texture_path
    
    EventBus.player_changed_display.emit(_data)


func rebuild_skills() -> void:
    ability_container.ability_list = []
    
    for i in config_skills:
        var new_ability:FlowerAbility = Master.get_ability_by_id(i)# config_skills[i])
        ability_container.add_a_ability(new_ability)
        
        for x in config_skills[i]:
            var _sub_ability:FlowerAbility = Master.get_ability_by_id(config_skills[i])
            _sub_ability.is_sub_ability = true
            new_ability.sub_ability.append(_sub_ability)
    
    EventBus.player_ability_change.emit()


func compute() -> void:
    flower_buff_manager.compute_only_values()


func compute_all() -> void:
    flower_buff_manager.compute()


func move_to_enemy() -> void:
    if current_state == STATE.DEAD:
        return
    
    if not closest_enemy:
        find_closest_enemy()
        return
    
    turn_to_closest_enemy()
    
    #if ray_cast.is_colliding():
        #print("ok")
        #attack()
        #closest_enemy = ray_cast.get_collider()
        #return
    
    update_navigation_position()
    
    if not navigation_agent_2d.is_navigation_finished():
        #var _direction:Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
        var _direction:Vector2 = global_position.direction_to(navigation_agent_2d.get_next_path_position())
        velocity = _direction * output_data.speed
    #velocity = global_position.\
    #direction_to(closest_enemy.marker.global_position) * output_data.speed
    
    character_animation_player.play("scml/Walking")


func ranged_attack() -> void:
    ranged_weapon.attack()


func attack() -> void:
    if current_state == STATE.DEAD:
        return
    
    velocity = Vector2.ZERO
    
    # 攻击代码
    if current_state == STATE.DEAD:
        return
    
    #if global_position != closest_enemy.marker.global_position:
        #global_position = closest_enemy.marker.global_position
    
    turn_to_closest_enemy()
    
    #if not ability_container.ability_list.is_empty():
        #ability_container.active_a_ability(ability_container.ability_list[0])
        #current_state = STATE.ATTACKING
        #return
    
    character_animation_player.play("scml/Attacking")
    current_state = STATE.ATTACKING


func turn_to_closest_enemy() -> void:
    var _dir:Vector2 = to_local(closest_enemy.global_position).normalized()
    
    if _dir.x > 0:
            # Right
        self.scale.x = 1
    elif  _dir.x < 0:
        self.scale.x = -1


func _physics_process(_delta:float) -> void:
    if current_state == STATE.IDLE:
        find_closest_enemy()
    
    if current_state == STATE.ATTACKING:
        if not closest_enemy:
            find_closest_enemy()
        #if global_position.distance_to(closest_enemy.global_position) >= 1000.0:
            #find_closest_enemy()
    
    if current_state == STATE.MOVE_TO_ENEMYING:
        move_to_enemy()
    
    if current_state == STATE.DEAD:
        return
    
    move_and_slide()


func get_ability_list() -> Array:
    var _list:Array = []
    _list = ability_container.ability_list
    return _list


func get_level() -> int:
    return output_data.level


func change_weapons_sprite(_sprite:Texture2D) -> void:
    sprites["weapon"].texture = _sprite
    sprites["weapon"].centered = false


func change_head_sprite(_sprite:Texture2D) -> void:
    sprites["head"].texture = _sprite
    sprites["head"].centered = false


func change_body_sprite(_sprite:Texture2D) -> void:
    sprites["body"].texture = _sprite
    sprites["body"].centered = false


# ======= 属性 ========
func up_level() -> void:
    compute_data.level_up()
    compute_data.now_xp = 0
    compute_data.update_next_xp()
    compute_all()
    EventBus.player_level_up.emit()
    EventBus.player_data_change.emit()
    EventBus.update_ui.emit()
    EventBus.get_talent_point.emit(1)


func get_xp(_value:float) -> void:
    compute_data.now_xp += _value
    EventBus.update_ui.emit()
    
    if compute_data.now_xp <= compute_data.next_level_xp:
        return
    
    if compute_data.level >= 100 + (Master.fly_count * 10):
        EventBus.new_tips.emit("达到等级上限！请转生以提升等级上限！")
        return
    
    up_level()

# ======= 战斗 ========
func relife() -> void:
    Tracer.info("玩家复活")
    global_position = Master.relife_point.global_position
    character_animation_player.play_backwards("scml/Dying")
    await character_animation_player.animation_finished
    
    compute_all()
    
    reset_player_hp_and_magic()
        
    EventBus.update_ui.emit()
    
    hurt_box_collision.call_deferred("set_disabled", false)    
    
    current_state = STATE.IDLE
    
    EventBus.player_relife.emit()


func die() -> void:
    current_state = STATE.DEAD
    Tracer.info("玩家死亡")
    
    velocity = Vector2.ZERO
    
    hurt_box_collision.call_deferred("set_disabled", true)
    
    EventBus.player_dead.emit()
    
    if Master.current_location == Const.LOCATIONS.TOWER:
        EventBus.exit_tower.emit()
        
    character_animation_player.play("scml/Dying")
    await character_animation_player.animation_finished
    relife()


func find_closest_enemy(_temp = 0) -> void:
    if current_state == STATE.DEAD:
        #Tracer.debug("玩家寻找最近敌人，但是死亡，所以return")
        return
    
    current_state = STATE.FINDING
    
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
    
    if closest_enemy != null:
        ranged_weapon.target_position = closest_enemy.global_position
    else:
        ranged_weapon.target_position = global_position + Vector2(200, 200)
    
    atk_range.target = closest_enemy
    vision.target = closest_enemy
    
    update_navigation_position()
    
    current_state = STATE.MOVE_TO_ENEMYING


func update_navigation_position() -> void:
    if closest_enemy:
        #navigation_agent_2d.target_position = closest_enemy.global_position
        navigation_agent_2d.target_position = closest_enemy.marker.global_position
    else:
        navigation_agent_2d.target_position = global_position
