extends Node2D

@onready var animation:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    animation.play("run")
    EventBus.flyed.emit()
    await animation.animation_finished
    Master.should_load = true
    #FlowerLoader.change_scene(self, "res://Scene/World.tscn")
    get_tree().change_scene_to_packed(load("res://Scene/World.tscn"))
    #EventBus.change_scene.emit(self, "res://Scene/World.tscn")
