extends Node2D

@export var save:bool = false
@export var load_save:bool = false

func _ready() -> void:
    Master.world = self
     
    SoundManager.play_music(load(Master.BGM), 0, "Music")
    
    if not save:
        return
    if SaveSystem.has("Player"):
        print("读档！")
        EventBus.load_save.emit()
