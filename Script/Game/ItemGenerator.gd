class_name ItemGenerator extends Node

func gen_a_item() -> InventoryItem:
    var _new_item:InventoryItem = InventoryItem.new()
    
    _new_item.name = "掉落剑"
    
    return _new_item
