extends Timer

@onready var save_cd:Timer = $SaveCD

func _ready() -> void:
    wait_time = 0.5
    one_shot = true
    autostart = false
    
    save_cd.wait_time = 0.5
    save_cd.one_shot = true
    save_cd.autostart = false
    
    timeout.connect(func():
        EventBus.save.emit()
        save_cd.start()
        await save_cd.timeout
        
        if not get_parent().save:
            return
        
        FlowerSaver.save(Master.current_save_slot)
        print("存档完成")
        start()
        )
    
    start()
