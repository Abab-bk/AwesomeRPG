extends Control

func _ready() -> void:
    $AnimationPlayer.play("run")
    await $AnimationPlayer.animation_finished
    get_tree().change_scene_to_packed(load("res://Scene/UI/MainMenu.tscn"))
