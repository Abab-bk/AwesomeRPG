extends Node

signal update_ui
signal update_inventory
signal change_item_tooltip_state(item:InventoryItem)
# Player 的 ComputeData 改变
signal player_data_change

signal player_hited(damage:int)
signal player_dead
signal player_ability_change
signal player_ability_activate(ability:FlowerAbility)
signal player_get_a_ability(ability:FlowerAbility)
signal equipment_up(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_down(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_down_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_up_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem)

signal enemy_die(xp:int)

signal add_item(item:InventoryItem)
# 新掉落物品（在游戏世界里）
signal new_drop_item(item:InventoryItem, pos:Vector2)
