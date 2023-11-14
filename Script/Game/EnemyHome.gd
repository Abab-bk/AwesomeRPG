class_name EnemyHome extends Node2D

@export var max_enemy_count:int = 300:
    set(v):
        if v >= 300:
            v = 300
            max_enemy_count = v
            return
        max_enemy_count = v

@export var min_enemy_count:int = 5

# TODO: 待完善 关卡系统
var killed_enemys:int = 0
var need_killed_enemys:int = 50

func _ready() -> void:
    EventBus.enemy_die.connect(gen_a_enemy)
    EventBus.player_level_up.connect(func():
        min_enemy_count += 2
        )
    EventBus.completed_level.connect(func():
        killed_enemys = 0
        need_killed_enemys = min_enemy_count * 50
        )
    EventBus.enemy_die.connect(func(_temp):
        killed_enemys += 1
        if killed_enemys >= need_killed_enemys:
            EventBus.completed_level.emit()
        )

func kill_all_enemy() -> void:
    for i in get_children():
        i.queue_free()

func gen_a_enemy(_temp = 0) -> void:
    var _current_enemy_count:int = get_tree().get_nodes_in_group("Enemy").size()
    
    if _current_enemy_count >= max_enemy_count:
        return
    
    if _current_enemy_count < min_enemy_count:
        for i in min_enemy_count - _current_enemy_count:
            spawn_a_enemy_by_id(Master.enemys.keys().pick_random())
            #spawn_a_enemy()
        return
    
    spawn_a_enemy_by_id(Master.enemys.keys().pick_random())
    #spawn_a_enemy()

func spawn_a_special_enemy(_reward:Callable, _id:int) -> void:
    var _enemy_data = Master.enemys[_id]
    
    var new_enemy:Enemy = Builder.build_a_enemy()
    
    new_enemy.skin_name = _enemy_data["skin_name"]
    
    var _data:CharacterData = CharacterData.new()
    _data.damage = _enemy_data["base_damage"]
    _data.frost_damage = _enemy_data["frost_damage"]
    _data.fire_damage = _enemy_data["fire_damage"]
    _data.light_damage = _enemy_data["light_damage"]
    _data.toxic_damage = _enemy_data["toxic_damage"]
    _data.frost_resistance = _enemy_data["frost_resistance"]
    _data.fire_resistance = _enemy_data["fire_resistance"]
    _data.light_resistance = _enemy_data["light_resistance"]
    _data.toxic_resistance = _enemy_data["toxic_resistance"]
    _data.max_hp = _enemy_data["hp"]
    _data.hp = _enemy_data["hp"]
    _data.speed = _enemy_data["speed"]
    
    new_enemy.set_data(_data)
    call_deferred("add_child", new_enemy)
    # 在 Enemy 脚本中设置等级及其他属性，因为 data 需要时间读取并赋值
    new_enemy.global_position = Vector2(randi_range(-347, 2935), randi_range(-117, 2751))
    Master.player.find_closest_enemy()
    new_enemy.dead.connect(_reward)

func spawn_a_enemy() -> void:
    var new_enemy:Enemy = Builder.build_a_enemy()
    call_deferred("add_child", new_enemy)
    # 在 Enemy 脚本中设置等级及其他属性，因为 data 需要时间读取并赋值
    new_enemy.global_position = Vector2(randi_range(-347, 2935), randi_range(-117, 2751))
    Master.player.find_closest_enemy()

func spawn_a_enemy_by_id(_id:int) -> void:
    var _enemy_data = Master.enemys[_id]
    
    var new_enemy:Enemy = Builder.build_a_enemy()
    
    new_enemy.skin_name = _enemy_data["skin_name"]
    
    var _data:CharacterData = CharacterData.new()
    _data.damage = _enemy_data["base_damage"]
    _data.frost_damage = _enemy_data["frost_damage"]
    _data.fire_damage = _enemy_data["fire_damage"]
    _data.light_damage = _enemy_data["light_damage"]
    _data.toxic_damage = _enemy_data["toxic_damage"]
    _data.frost_resistance = _enemy_data["frost_resistance"]
    _data.fire_resistance = _enemy_data["fire_resistance"]
    _data.light_resistance = _enemy_data["light_resistance"]
    _data.toxic_resistance = _enemy_data["toxic_resistance"]
    _data.max_hp = _enemy_data["hp"]
    _data.hp = _enemy_data["hp"]
    _data.speed = _enemy_data["speed"]
    
    new_enemy.set_data(_data)
    call_deferred("add_child", new_enemy)    
    new_enemy.global_position = Vector2(randi_range(-347, 2935), randi_range(-117, 2751))
    Master.player.find_closest_enemy()
