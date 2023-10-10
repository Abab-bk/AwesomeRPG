extends CharacterBody2D

@onready var flower_buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var animation_player:AnimationPlayer = $AnimationPlayer

var data:CharacterData
var target:Vector2 = global_position

var closest_distance:float = 1000000
var closest_enemy:Enemy
var all_enemy:Array

func _ready() -> void:
    Master.player = self
    EventBus.player_dead.connect(relife)
    EventBus.enemy_die.connect(find_closest_enemy)
    
    data = flower_buff_manager.compute_data

func _physics_process(delta: float) -> void:
    move_and_slide()

func relife() -> void:
    # FIXME: data是资源，不会唯一化
    data.hp = data.max_hp
    global_position = Master.relife_point.global_position
    animation_player.play_backwards("Die")
    await animation_player.animation_finished

func die() -> void:
    animation_player.play("Die")
    await animation_player.animation_finished
    EventBus.player_dead.emit()

func find_closest_enemy() -> void:
    all_enemy = get_tree().get_nodes_in_group("Enemy")
    
    for enemy in all_enemy:
        if not closest_enemy:
            closest_enemy = enemy
        
        var enemy_distance = position.distance_to(enemy.position)
        if enemy_distance < closest_distance:
            closest_distance = enemy_distance
            closest_enemy = enemy

# ======== 移动 =========
#func _input(event):
#    if event.is_action_pressed("Click"):
#        target = get_global_mouse_position()
#
#func _physics_process(_delta):
#    velocity = position.direction_to(target) * data.speed
#    if position.distance_to(target) > 10:
#        move_and_slide()
