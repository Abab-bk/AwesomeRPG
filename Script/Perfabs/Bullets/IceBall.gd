class_name IceBall extends CharacterBody2D

@onready var hit_box:SimpleHitBoxComponent = $SimpleHitBoxComponent

var hited_function:Callable = func():pass

func _ready() -> void:
    hit_box.disable_target = Master.player
    hit_box.handled_hit.connect(func(_temp, _temp2, _temp3):
        hited_function.call()
        )

func get_enemys() -> Array:
    return hit_box.get_enemys()

func set_damage_data(data:CharacterData) -> void:
    hit_box.damage_data = data

func set_damage(value:float) -> void:
    hit_box.damage = value

func _physics_process(_delta: float) -> void:
    move_and_slide()

func auto_to_queue_free(_time:float) -> void:
    await get_tree().create_timer(_time).timeout
    queue_free()
