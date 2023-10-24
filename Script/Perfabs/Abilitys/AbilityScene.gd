class_name AbilityScene extends Node2D

var actor:Player

func timeout() -> void:
    queue_free()
