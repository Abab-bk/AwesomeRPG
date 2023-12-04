extends Node

func _ready() -> void:
    EventBus.unlocked_ability.emit(4009)
