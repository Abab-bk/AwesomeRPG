class_name Inventory extends Resource

@export var items:Array[InventoryItem]
@export var size:int

func add_item(_item:InventoryItem) -> void:
    print("添加装备：", _item)
    if items.size() >= size:
        return
    items.append(_item)

func remove_item(_item:InventoryItem) -> void:
    items.erase(_item)

func remove_all_item() -> void:
    items.clear()

@warning_ignore("native_method_override")
func get_class() -> String:
    return "res://Script/Game/System/Inventory.gd"
