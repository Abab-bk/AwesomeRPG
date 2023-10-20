extends Node2D

func _ready() -> void:
    EventBus.enemy_die.connect(gen_a_enemy)

func gen_a_enemy(_temp = 0) -> void:
    var new_enemy:Enemy = Builder.build_a_enemy()
    get_parent().call_deferred("add_child", new_enemy)
    # 在 Enemy 脚本中设置等级及其他属性，因为 data 需要时间读取并赋值
    new_enemy.global_position = Vector2(randi_range(-347, 2935), randi_range(-117, 2751))
