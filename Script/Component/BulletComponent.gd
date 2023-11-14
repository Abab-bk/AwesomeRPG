class_name BulletComponent extends CharacterBody2D

var target_pos:Vector2 = Vector2(0, 0)
var speed:float = 1000.0

func _ready() -> void:
    collision_layer = 0
    collision_mask = 0
    
    set_collision_mask_value(4, true)
    
    await get_tree().create_timer(1.0).timeout
    queue_free()

func _physics_process(_delta:float) -> void:
    velocity = global_position.direction_to(target_pos) * speed
    move_and_slide()
