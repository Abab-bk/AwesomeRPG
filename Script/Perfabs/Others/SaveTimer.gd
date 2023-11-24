extends Timer

func _ready() -> void:
    timeout.connect(func():
        EventBus.save.emit()
        
        if not get_parent().save:
            return
        
        FlowerSaver.save(Master.current_save_slot)
        #print("存档完成")
        )
