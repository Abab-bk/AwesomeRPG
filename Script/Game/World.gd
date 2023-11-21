extends Node2D

@export var save:bool = false
@export var load_save:bool = false

@onready var enemy_home:EnemyHome = %EnemyHome

func _ready() -> void:
    Master.world = self
    
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
    
    EventBus.completed_level.emit()
    EventBus.update_ui.emit()
    EventBus.load_save.connect(completed_level)

    SoundManager.play_music(load(Master.BGM), 0, "Music")
    
    if Master.should_load:
        FlowerSaver.load_save(Master.current_save_slot)
        print("加载存档 - 世界")
        EventBus.load_save.emit()    

func completed_level() -> void:
    enemy_home.min_enemy_count = Master.current_level * 1
    enemy_home.max_enemy_count = Master.current_level * 5

# TODO: 副本得到奖励
func get_data_reward(_data:DungeonData) -> void:
    match _data.reward_type:
        "Coins":
            Master.coins += _data.reward_value
