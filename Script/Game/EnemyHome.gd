extends Node2D

func _ready() -> void:
    EventBus.enemy_die.connect(gen_a_enemy)

func gen_a_enemy(_temp = 0) -> void:
    var new_enemy = Builder.builder_a_enemy()
    get_parent().call_deferred("add_child", new_enemy)
    new_enemy.global_position = Vector2(randi_range(-347, 2935), randi_range(-117, 2751))
