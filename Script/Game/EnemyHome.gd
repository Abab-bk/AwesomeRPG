extends Node2D

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

func gen_a_enemy(_temp = 0) -> void:
    var _current_enemy_count:int = get_tree().get_nodes_in_group("Enemy").size()
    
    if _current_enemy_count >= max_enemy_count:
        return
    
    if _current_enemy_count < min_enemy_count:
        for i in min_enemy_count - _current_enemy_count:
            spawn_a_enemy()
        return
    
    spawn_a_enemy()

func spawn_a_enemy() -> void:
    var new_enemy:Enemy = Builder.build_a_enemy()
    get_parent().call_deferred("add_child", new_enemy)
    # 在 Enemy 脚本中设置等级及其他属性，因为 data 需要时间读取并赋值
    new_enemy.global_position = Vector2(randi_range(-347, 2935), randi_range(-117, 2751))
    Master.player.find_closest_enemy()
