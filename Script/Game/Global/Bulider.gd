extends Node

const enemy := preload("res://Scene/Perfabs/NonPlayCharacter/Enemy.tscn")

func builder_a_enemy() -> Enemy:
    var _n = enemy.instantiate()
    return _n
