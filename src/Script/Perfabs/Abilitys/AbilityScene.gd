class_name AbilityScene extends Node2D

var actor:Player
var ability_data:FlowerAbility

func timeout() -> void:
    queue_free()
