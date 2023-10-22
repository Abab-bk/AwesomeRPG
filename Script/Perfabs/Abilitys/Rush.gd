extends Node2D

var temp
var actor:Player

func _ready() -> void:
    temp = actor.data.speed
    actor.data.speed += 200
    
    await $Timer.timeout
    
    actor.data.speed = temp
    queue_free()
