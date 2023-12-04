extends HBoxContainer

@onready var coins_label:Label = %CoinsLabel

@export var target:String = ""

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)
    EventBus.coins_changed.connect(update_ui)

func update_ui() -> void:
    coins_label.text = str(Master[target])
