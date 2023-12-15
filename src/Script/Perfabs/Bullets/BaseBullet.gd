class_name BaseBullet extends CharacterBody2D

@export var damage_data:CharacterData
@export var is_player_bullet:bool = false

@onready var hit_box:HitBoxComponent = $HitBoxComponent as HitBoxComponent


func _ready() -> void:
    hit_box.is_player_hitbox = is_player_bullet
    # Tracer.info("基础子弹：%s" % str(is_player_bullet))
    hit_box.damage_data = damage_data
    hit_box.reset_collision()


func update_velocity() -> void:
    velocity = global_position.\
    direction_to(Master.player.global_position) * damage_data.speed
    look_at(Master.player.global_position)


func _physics_process(_delta:float) -> void:
    move_and_slide()
