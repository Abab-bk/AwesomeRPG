extends Node

@export var debuger:bool = false

func _ready() -> void:
    if not debuger:
        return
    EventBus.unlocked_ability.emit(4009)
    
