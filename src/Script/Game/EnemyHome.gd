class_name EnemyHome extends Node2D

@export var max_enemy_count:int = 300:
    set(v):
        if v >= 300:
            v = 300
            max_enemy_count = v
            return
        max_enemy_count = v

@export var min_enemy_count:int = 5

@onready var point_1:Marker2D = $"../RelifePoint/SpawnPoint/Point1"
@onready var point_2:Marker2D = $"../RelifePoint/SpawnPoint/Point2"
@onready var point_3:Marker2D = $"../RelifePoint/SpawnPoint/Point3"
@onready var point_4:Marker2D = $"../RelifePoint/SpawnPoint/Point4"

var killed_enemys:int = 0
var need_killed_enemys:int = 50

var current_tower_all_enemy_count:int = 0
var current_tower_killed_enemy_count:int = 0

func _ready() -> void:
    EventBus.enemy_die.connect(gen_a_enemy)
    EventBus.player_level_up.connect(func():
        min_enemy_count += 2
        )
    EventBus.completed_level.connect(func():
        killed_enemys = 0
        need_killed_enemys = min_enemy_count * 50
        Master.next_level_need_kill_count = need_killed_enemys - killed_enemys
        )
    
    EventBus.enemy_die.connect(func(_temp):
        if Master.current_location == Const.LOCATIONS.TOWER:
            current_tower_killed_enemy_count += 1
            
            Master.need_kill_enemys_to_next_tower = current_tower_all_enemy_count - current_tower_killed_enemy_count
            
            if current_tower_killed_enemy_count >= current_tower_all_enemy_count:
                EventBus.go_to_next_tower_level.emit()
                update_tower_enemys()
            
            return
        
        killed_enemys += 1
        
        Master.next_level_need_kill_count = need_killed_enemys - killed_enemys
        
        if killed_enemys >= need_killed_enemys:
            EventBus.completed_level.emit()
        
        if killed_enemys - need_killed_enemys == 1:
            spawn_a_boss_enemy(Master.enemys.keys().pick_random())
        )
    
    EventBus.flyed.connect(kill_all_enemy)
    EventBus.kill_alll_enenmy.connect(kill_all_enemy)
    EventBus.start_climb_tower.connect(func():
        kill_all_enemy()
        update_tower_enemys()
        gen_a_enemy()
        )
    EventBus.exit_tower.connect(func():
        current_tower_all_enemy_count = 0
        current_tower_killed_enemy_count = 0
        kill_all_enemy()
        gen_a_enemy()
        )
    EventBus.exit_dungeon.connect(func():
        kill_all_enemy()
        gen_a_enemy()
        )


func kill_all_enemy() -> void:
    for i in get_children():
        i.queue_free()


func update_tower_enemys() -> void:
    if Master.current_tower_level >= 50:
        current_tower_all_enemy_count = Master.current_tower_level * 20
    else:
        current_tower_all_enemy_count = Master.current_tower_level * 10


func gen_a_enemy(_temp = 0) -> void:
    # 如果是在爬塔
    if Master.current_location == Const.LOCATIONS.TOWER:
        var _current_level_enemy_count:int = get_tree().get_nodes_in_group("Enemy").size()
        
        if _current_level_enemy_count >= max_enemy_count:
            return
        
        spawn_a_enemy_by_id(Master.enemys.keys().pick_random())
        
        return
    
    # 普通生成
    var _current_enemy_count:int = get_tree().get_nodes_in_group("Enemy").size()
    
    if _current_enemy_count >= max_enemy_count:
        return
    
    if _current_enemy_count < min_enemy_count:
        for i in min_enemy_count - _current_enemy_count:
            #spawn_a_enemy_by_id(7007)
            spawn_a_enemy_by_id(Master.enemys.keys().pick_random())
        return
    
    spawn_a_enemy_by_id(Master.enemys.keys().pick_random())
    #spawn_a_enemy_by_id(7007)


func spawn_a_boss_enemy(_id:int) -> void:
    var _enemy_data = Master.dungeon_enemys[_id]
    
    var new_enemy:Enemy = Builder.build_a_enemy() as Enemy
    
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
    
    new_enemy.set_data(_data, true)
    call_deferred("add_child", new_enemy)
    # 在 Enemy 脚本中设置等级及其他属性，因为 data 需要时间读取并赋值
    new_enemy.global_position = get_random_pos()
    Master.player.find_closest_enemy()
    new_enemy.dead.connect(func():
        EventBus.boss_dead.emit()
        )
    
    EventBus.boss_appear.emit(_data)



func spawn_a_special_enemy(_reward:Callable, _id:int) -> void:
    var _enemy_data = Master.dungeon_enemys[_id]
    
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
    new_enemy.global_position = get_random_pos()
    Master.player.find_closest_enemy()
    new_enemy.dead.connect(_reward)


func spawn_a_enemy() -> void:
    var new_enemy:Enemy = Builder.build_a_enemy()
    call_deferred("add_child", new_enemy)
    # 在 Enemy 脚本中设置等级及其他属性，因为 data 需要时间读取并赋值
    new_enemy.global_position = get_random_pos()
    Master.player.find_closest_enemy()


func spawn_a_enemy_by_id(_id:int) -> void:
    var _enemy_data = Master.enemys[_id]
    
    var new_enemy:Enemy = Builder.build_a_enemy() as Enemy
    
    new_enemy.skin_name = _enemy_data["skin_name"]
    
    var _data:CharacterData = CharacterData.new()
    _data.atk_cd = _enemy_data["base_atk_cd"]
    _data.vision = _enemy_data["base_vision"]
    _data.atk_range = _enemy_data["base_atk_range"]
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
    new_enemy.global_position = get_random_pos()
    Master.player.find_closest_enemy()


func get_random_pos() -> Vector2:
    return Vector2(randf_range(point_1.global_position.x, point_4.global_position.x), randf_range(point_1.global_position.y, point_2.global_position.y))
