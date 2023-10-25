class_name Player extends CharacterBody2D

# TODO: 优化玩家寻找敌人逻辑

@onready var ability_container:FlowerAbilityContainer = $FlowerAbilityContainer
@onready var flower_buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var animation_player:AnimationPlayer = $AnimationPlayer

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
        
        # 装备装备时，应用装备 Buff
        for i in _item.pre_affixs:
            flower_buff_manager.add_buff(i.buff)
        
        for i in _item.buf_affix:
            flower_buff_manager.add_buff(i.buff)
        
        # 更新 UI
        EventBus.equipment_up_ok.emit(_type, _item))
    
    EventBus.equipment_down.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            data.quipments[_type] = null
            
            # TODO: remove的时候可以先不计算，全部remove完成后再计算
            for i in _item.pre_affixs:
                flower_buff_manager.remove_buff(i.buff)
            for i in _item.buf_affix:
                flower_buff_manager.remove_buff(i.buff)
            
            print("移除装备")
            EventBus.equipment_down_ok.emit(_type, _item))
    
    EventBus.player_ability_activate.connect(func(_ability:FlowerAbility):
        ability_container.active_a_ability(_ability)
        )
    
    EventBus.player_set_a_ability.connect(func(_ability_id:int,
    _sub_ability:Array):
        if _ability_id in config_skills:
            config_skills[_ability_id].append_array(_sub_ability)
            EventBus.sub_ability_changed.emit(_ability_id, _sub_ability)
        else:
            config_skills[_ability_id] = _sub_ability
            EventBus.sub_ability_changed.emit(_ability_id, _sub_ability)
        
        for i in config_skills.keys():
            ability_container.add_a_ability(Master.get_ability_by_id(i))
        
        EventBus.player_ability_change.emit()
        )
    
    EventBus.enemy_die.connect(get_xp)
    
    # TODO: 完善存档
    EventBus.save.connect(func():
        SaveSystem.set_var("Player", data)
#        SaveSystem.set_var("Player:Abilitys", ability_container.ability_list)
        )
    
    EventBus.load_save.connect(func():
        print(SaveSystem.get_var("Player"))
        data.load_save(SaveSystem.get_var("Player"))
#        ability_container.ability_list = SaveSystem.get_var("Player:Abilitys")
        )
    
    flower_buff_manager.compute_ok.connect(func():
        EventBus.player_data_change.emit()
        Master.player_data = flower_buff_manager.output_data
        print("计算完成")
        )
#    flower_buff_manager.a_buff_removed
    
    data = flower_buff_manager.compute_data
    flower_buff_manager.output_data = data.duplicate(true)
    Master.player_data = flower_buff_manager.output_data
    
    compute()
    
    $Sprite2D/Weapons/WeaponComponent.set_dis_target(self)

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

func _physics_process(_delta: float) -> void:
    move_and_slide()

func get_ability_list() -> Array:
    var _list:Array = []
    _list = ability_container.ability_list
    return _list

func get_level() -> int:
    return data.level

# ======= 属性 ========
func up_level() -> void:
    data.level += 1
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
    animation_player.play_backwards("Die")
    await animation_player.animation_finished

func die() -> void:
    animation_player.play("Die")
    await animation_player.animation_finished
    EventBus.player_dead.emit()

func find_closest_enemy(_temp = 0) -> void:
    all_enemy = get_tree().get_nodes_in_group("Enemy")
    
    for enemy in all_enemy:
        if not closest_enemy:
            closest_enemy = enemy
        
        var enemy_distance = position.distance_to(enemy.position)
        if enemy_distance < closest_distance:
            closest_distance = enemy_distance
            closest_enemy = enemy
