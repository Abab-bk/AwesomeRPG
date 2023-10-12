extends Node

signal update_ui
signal update_inventory
signal change_item_tooltip_state(item:InventoryItem)

signal player_hited(damage:int)
signal player_dead
signal equipment_up(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_down(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_down_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_up_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem)

signal enemy_die

signal add_item(item:InventoryItem)
signal new_drop_item(item:InventoryItem, pos:Vector2)
