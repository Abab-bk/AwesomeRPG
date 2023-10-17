extends Control

var world := preload("res://Scene/World.tscn")

func _ready() -> void:
    $AnimationPlayer.play("run")
    await $AnimationPlayer.animation_finished
    get_tree().change_scene_to_packed(world)
