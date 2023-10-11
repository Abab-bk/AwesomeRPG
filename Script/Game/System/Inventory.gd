class_name Inventory extends Resource

@export var items:Array[InventoryItem]
@export var size:int

func add_item(_item:InventoryItem) -> void:
    if items.size() >= size:
        return
    items.append(_item)

func remove_item(_item:InventoryItem) -> void:
    items.erase(_item)
