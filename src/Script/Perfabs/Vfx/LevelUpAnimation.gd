extends Node2D

@onready var animation_player:AnimatedSprite2D = $AnimatedSprite2D

func _ready():
    animation_player.play("default")
    await animation_player.animation_finished
    queue_free()