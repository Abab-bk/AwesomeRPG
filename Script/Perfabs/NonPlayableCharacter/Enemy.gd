class_name Enemy
extends CharacterBody2D

@onready var buff_manager:FlowerBuffManager = $FlowerBuffManager

func _physics_process(_delta:float) -> void:
    move_and_slide()
