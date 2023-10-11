extends Node

const enemy := preload("res://Scene/Perfabs/NonPlayCharacter/Enemy.tscn")
const inventory_item := preload("res://Scene/UI/InventoryItem.tscn")

func builder_a_enemy() -> Enemy:
    var _n = enemy.instantiate()
    return _n

func builder_a_inventory_item() -> Panel:
    var _n = inventory_item.instantiate()
    return _n
