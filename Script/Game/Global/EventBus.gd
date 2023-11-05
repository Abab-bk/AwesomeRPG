extends Node

signal save
signal load_save

signal update_ui
signal update_inventory
signal change_item_tooltip_state(item:InventoryItem)
signal show_popup(title:String, desc:String, show_cancel_btn:bool, yes_event:Callable, cancel_event:Callable)
signal show_select_skills_panel(target:Panel)
signal show_color
signal hide_color
signal new_tips(text:String)

signal selected_skills_on_panel
signal unlocked_ability(id:int)
signal sub_ability_changed(_ability_id:int, _sub_ability:Array)
# Player 的 ComputeData 改变
signal player_data_change
signal completed_level

signal coins_changed

signal player_criticaled
signal player_hited(damage:float)
signal player_dead
signal player_ability_change
signal player_ability_activate(ability:FlowerAbility)
signal player_set_a_ability(ability:FlowerAbility, sub_ability:Array)
signal player_level_up

signal equipment_up(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_down(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_down_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_up_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem)

signal enemy_die(xp:float)

signal show_damage_number(pos:Vector2, text:String)

signal enter_dungeon(dungeon:DungeonData)

signal add_item(item:InventoryItem)
signal remove_item(item:InventoryItem)
# 新掉落物品（在游戏世界里）
signal new_drop_item(item:InventoryItem, pos:Vector2)
