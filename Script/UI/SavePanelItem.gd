extends Panel

signal enter

@export var slot:int

@onready var player_level_label:Label = %PlayerLevelLabel
@onready var player_name_label:Label = %PlayerNameLabel

@onready var enter_btn:Button = %EnterBtn
@onready var del_btn:Button = %DelBtn

func _ready() -> void:
    enter_btn.pressed.connect(func():
        if enter_btn.text == "进入":
            Master.current_save_slot = get_slot_path()
            Master.should_load = true
            enter.emit()
            return
        Master.current_save_slot = get_slot_path()        
        enter.emit()
        )
    del_btn.pressed.connect(func():
        FlowerSaver.del_save(get_slot_path())
        )
    update_ui(FlowerSaver.get_data_but_load("player_output_data", get_slot_path()))


func get_slot_path() -> String:
    match slot:
        1:
            return FlowerSaver.save_path
        2:
            return FlowerSaver.save_path2
        3:
            return FlowerSaver.save_path3
    return "user://"


func update_ui(_data:Variant) -> void:
    if not _data:
        player_level_label.text = ""
        player_name_label.text = "暂无存档"
        enter_btn.text = "新建"
        del_btn.hide()
        return
    
    _data = _data as CharacterData
    
    player_level_label.text = str(_data.level)
    player_name_label.text = str("花神")
    enter_btn.text = "进入"
    del_btn.show()
