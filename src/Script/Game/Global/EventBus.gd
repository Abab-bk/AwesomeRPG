extends Node

signal save
signal load_save

signal change_scene(who:Node, to:String)

signal update_ui
signal update_inventory
signal change_item_tooltip_state(item:InventoryItem, down:bool, move:bool, display:bool, differ:bool)
signal change_differ_item_tooltip_state(item:InventoryItem, item2:InventoryItem, down:bool, move:bool, display:bool, differ:bool)
signal change_tooltip_display_state
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

signal go_to_next_tower_level
signal start_climb_tower
signal exit_tower

signal get_talent_point(count:int)

signal player_criticaled
signal player_hited(damage:float)
signal player_dead
signal player_relife
signal player_ability_change
signal player_ability_activate(ability:FlowerAbility)
signal player_set_a_ability(ability:FlowerAbility, sub_ability:Array)
signal player_level_up
signal player_get_healing_potion(key:String, num:int)
signal player_changed_display

signal rework_level_enemy_count

# 这里是爆出打造装备需要的金币
signal get_money(key:String, value:int)

signal flyed

signal get_friend(id:int)

signal equipment_up(type:Const.EQUIPMENT_TYPE, item:InventoryItem)
signal equipment_down(type:Const.EQUIPMENT_TYPE, item:InventoryItem, add_item:bool)
signal equipment_down_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem, add_item:bool)
signal equipment_up_ok(type:Const.EQUIPMENT_TYPE, item:InventoryItem)

signal changed_friends(data:Dictionary)
signal kill_all_friend

signal enhance_a_equipment

signal enemy_die(xp:float)

signal show_animation(key:String, data:Dictionary)
signal show_damage_number(pos:Vector2, text:String, crit:bool)

signal enter_dungeon(dungeon:DungeonData)

signal add_item(item:InventoryItem)
signal remove_item(item:InventoryItem)
# 移动到仓库
signal move_item(item:InventoryItem)
# 新掉落物品（在游戏世界里）
signal new_drop_item(item:InventoryItem, pos:Vector2)

signal unlock_new_function(key:String)

signal dialogue_ok(key:String)

signal kill_alll_enenmy
