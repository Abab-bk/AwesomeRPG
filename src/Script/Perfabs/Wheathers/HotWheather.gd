extends WheatherScene

@onready var timer:Timer = $Timer


func _ready() -> void:
    timer.timeout.connect(func():
        Master.player.output_data.hp -= 1
    )
    timer.start()
