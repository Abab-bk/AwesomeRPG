extends CharacterBody2D

@export var speed:int = 400

@onready var flower_buff_manager:FlowerBuffManager = $FlowerBuffManager

var data:CharacterData
var target:Vector2 = global_position

func _ready() -> void:
    Master.player = self
    
    EventBus.player_hited.connect(hited)
    EventBus.player_dead.connect(relife)
    
    data = flower_buff_manager.compute_data
    data.hp_is_zero.connect(die)
    
    speed = data.speed

func relife() -> void:
    data.hp = data.max_hp
    global_position = Master.relife_point.global_position

func hited(_damage:int) -> void:
    data.hp -= _damage

func die() -> void:
    EventBus.player_dead.emit()

func _input(event):
    if event.is_action_pressed("Click"):
        target = get_global_mouse_position()

func _physics_process(_delta):
    velocity = position.direction_to(target) * speed
    if position.distance_to(target) > 10:
        move_and_slide()
