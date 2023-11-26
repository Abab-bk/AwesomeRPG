extends Timer

func _ready() -> void:
    one_shot = true
    
    timeout.connect(func():
        EventBus.save.emit()
        
        if not get_parent().save:
            return
        
        FlowerSaver.save(Master.current_save_slot)
        await FlowerSaver.save_ok
        start()
        )
