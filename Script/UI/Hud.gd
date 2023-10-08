extends CanvasLayer

@onready var hp_bar:ProgressBar = %HpBar

var player_data:CharacterData

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)

    player_data = Master.player.data

    update_ui()

func update_ui() -> void:
    hp_bar.value = (float(player_data.hp) / float(player_data.max_hp)) * 100.0
