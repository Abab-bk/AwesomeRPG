extends Panel

@onready var change_btn:Button = %ChangeBtn

var data:FlowerAbility

func _ready() -> void:
    change_btn.pressed.connect(func():
        EventBus.show_select_skills_panel.emit()
        )
