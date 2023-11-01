extends Node2D

@export var data:DungeonData
var enemy_count:int
var player:Player

func _ready() -> void:
    for i in data.enemy_ids:
        spawn_a_enemy()

func spawn_a_enemy() -> void:
    var new_enemy:Enemy = Builder.build_a_enemy()
    get_parent().call_deferred("add_child", new_enemy)
    # 在 Enemy 脚本中设置等级及其他属性，因为 data 需要时间读取并赋值
    new_enemy.global_position = Vector2(randi_range(-347, 2935), randi_range(-117, 2751))
    player.find_closest_enemy()
