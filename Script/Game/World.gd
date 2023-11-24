extends Node2D

@export var save:bool = false
@export var load_save:bool = false

@onready var enemy_home:EnemyHome = %EnemyHome

func _ready() -> void:
    Master.world = self
    
    EventBus.rework_level_enemy_count.connect(rework_level_enemy_count)
    EventBus.completed_level.connect(completed_level)
    EventBus.flyed.connect(func():
        completed_level()
        EventBus.completed_level.emit()
        EventBus.update_ui.emit()
        )
    
    EventBus.enter_dungeon.connect(func(_data:DungeonData):
        Master.in_dungeon = true
        enemy_home.kill_all_enemy()
        enemy_home.spawn_a_special_enemy(func():
            # 地牢奖励
            get_data_reward(_data)
            Master.in_dungeon = false, _data.enemy_id))
    
    if Master.current_level == 0:
        EventBus.completed_level.emit()
    EventBus.update_ui.emit()
    #EventBus.load_save.connect(completed_level)

    SoundManager.play_music(load(Master.BGM), 0, "Music")
    
    if Master.should_load:
        FlowerSaver.load_save(Master.current_save_slot)
        print("加载存档 - 世界")
        EventBus.load_save.emit()
        Master.should_load = false

func rework_level_enemy_count() -> void:
    completed_level()

func completed_level() -> void:
    enemy_home.min_enemy_count = Master.current_level * 1
    enemy_home.max_enemy_count = Master.current_level * 5


func get_data_reward(_data:DungeonData) -> void:
    match _data.reward_type:
        "Coins":
            Master.coins += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s 金币" % str(_data.reward_value))
        "MoneyWhite":
            Master.moneys.white += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.white])
        "MoneyBlue":
            Master.moneys.blue += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.blue])
        "MoneyPurple":
            Master.moneys.purple += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.purple])
        "MoneyYellow":
            Master.moneys.yellow += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.yellow])
