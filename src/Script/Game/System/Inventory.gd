class_name Inventory extends Resource

@export var items:Array[InventoryItem] = []
@export var size:int = 50

func add_item(_item:InventoryItem) -> void:
    if items.size() >= size:
        return
    items.append(_item)
    EventBus.save_inventory.emit()

func remove_item(_item:InventoryItem) -> void:
    items.erase(_item)
    EventBus.save_inventory.emit()

func remove_all_item() -> void:
    items.clear()
