class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager

var dead:bool = false

func die() -> void:
    if dead:
        return
    dead = true
    $AnimationPlayer.play("Die")
    await $AnimationPlayer.animation_finished
    EventBus.enemy_die.emit()
    queue_free()

func _physics_process(_delta:float) -> void:
    move_and_slide()
