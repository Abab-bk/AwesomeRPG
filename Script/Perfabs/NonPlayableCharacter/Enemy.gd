class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var item_generator:ItemGenerator = $ItemGenerator
@onready var hp_bar:ProgressBar = %HpBar

var dead:bool = false
var data:CharacterData

func _ready() -> void:
    data = buff_manager.compute_data
    # 设置属性 （每个敌人 ready 都是生成）
    var _level:int = 1
    
    if Master.player.get_level() >= 5:
        _level = Master.player.get_level() - 3
    
    set_level(_level)

func die() -> void:
    if dead:
        return
    dead = true
    
    var _drop_item:InventoryItem = item_generator.gen_a_item()
    EventBus.new_drop_item.emit(_drop_item, global_position)
    
    $AnimationPlayer.play("Die")
    await $AnimationPlayer.animation_finished
    # 获得经验
    EventBus.enemy_die.emit(data.level * 10)
    
    queue_free()

func set_property_from_level() -> void:
    for i in data.get_property_list():
        pass

func set_level(_value:int) -> void:
    data.level = _value

func _physics_process(_delta:float) -> void:
    move_and_slide()
    hp_bar.value = (float(data.hp) / float(data.max_hp)) * 100.0
