extends Control

@onready var level_label:Label = %LevelLabel
@onready var timer:Timer = $Timer

func _ready() -> void:
    level_label.text = str(Master.player_output_data.level)
    
    timer.start()
    await timer.timeout
    queue_free()
