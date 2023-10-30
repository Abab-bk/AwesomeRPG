extends Node2D

@export var save:bool = false
@export var load_save:bool = false

@onready var enemy_home:Node2D = %EnemyHome

func _ready() -> void:
    Master.world = self
    
    EventBus.completed_level.connect(func():
        enemy_home.min_enemy_count = Master.current_level * 1
        enemy_home.max_enemy_count = Master.current_level * 5
        )
    
    EventBus.completed_level.emit()
    EventBus.update_ui.emit()
    
    SoundManager.play_music(load(Master.BGM), 0, "Music")
    
#    if not save:
#        return
#    if SaveSystem.has("Player"):
#        print("读档！")
#        EventBus.load_save.emit()
