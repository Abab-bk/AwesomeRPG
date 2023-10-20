extends Node2D

func _ready() -> void:
    Master.world = self
    
    if SaveSystem.has("Player"):
        print("读档！")
        EventBus.load_save.emit()
