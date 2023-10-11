extends Node

signal update_ui
signal update_inventory

signal player_hited(damage:int)
signal player_dead

signal enemy_die

signal add_item(item:InventoryItem)
signal new_drop_item(item:InventoryItem, pos:Vector2)
