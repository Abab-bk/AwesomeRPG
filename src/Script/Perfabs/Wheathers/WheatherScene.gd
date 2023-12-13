class_name WheatherScene extends Node2D

@export var wheather_info:WheatherData

func disappear() -> void:
    queue_free()
