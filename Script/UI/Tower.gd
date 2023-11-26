extends Control

@onready var start_btn:Button = %StartBtn
@onready var content_label:RichTextLabel = %ContentLabel
@onready var level_label:Label = %LevelLabel

var current_best_level:int = 0


func _ready() -> void:
    start_btn.pressed.connect(func():
        owner.change_page(owner.PAGE.HOME)
        EventBus.start_climb_tower.emit()
        )
    EventBus.exit_tower.connect(func():
        if Master.last_tallest_tower_level > current_best_level:
            current_best_level = Master.last_tallest_tower_level
        update_ui()
        )
    EventBus.save.connect(func():
        FlowerSaver.set_data("tower_current_best_level", current_best_level)
        )
    EventBus.load_save.connect(func():
        current_best_level = FlowerSaver.get_data("tower_current_best_level")
        update_ui()
        )

func update_ui() -> void:
    level_label.text = "当前最佳成绩：%s 层" % str(current_best_level)
