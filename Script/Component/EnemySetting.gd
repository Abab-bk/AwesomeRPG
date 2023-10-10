class_name EnemySetting extends Node

@export var enemy:Enemy
@export var blackboard:Blackboard
@export var tree:BeehaveTree

func _ready() -> void:
    tree.actor = enemy
    tree.blackboard = blackboard
