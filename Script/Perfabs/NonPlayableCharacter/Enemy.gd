class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var item_generator:ItemGenerator = $ItemGenerator

var dead:bool = false

func die() -> void:
    if dead:
        return
    dead = true
    
    var _drop_item:InventoryItem = item_generator.gen_a_item()
    EventBus.new_drop_item.emit(_drop_item, global_position)
    
    $AnimationPlayer.play("Die")
    await $AnimationPlayer.animation_finished
    EventBus.enemy_die.emit()
    queue_free()

func _physics_process(_delta:float) -> void:
    move_and_slide()
