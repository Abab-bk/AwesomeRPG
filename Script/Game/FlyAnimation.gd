extends Node2D

@onready var animation:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    animation.play("run")
    EventBus.flyed.emit()
    await animation.animation_finished
    EventBus.change_scene.emit(self, "res://Scene/World.tscn")
