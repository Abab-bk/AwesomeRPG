class_name QuestResource extends Resource

signal value_changed

enum QUEST_TYPE {
    KILL_ENEMY,
    ENHANCE_QUIPMENT,
    LEVEL_UP,
    NONE,
}

@export var id:int = 0
@export var name:String = ""
@export var desc:String = ""
@export var type:QUEST_TYPE = QUEST_TYPE.NONE
@export var reward_value:int = 0
@export var need_value:int = 0
@export var current_value:int = 0:
    set(v):
        current_value = v
        value_changed.emit()
@export var done:bool = false

func connect_signals() -> void:
    match type:
        QUEST_TYPE.KILL_ENEMY:
            EventBus.enemy_die.connect(get_progres)
        QUEST_TYPE.LEVEL_UP:
            EventBus.player_level_up.connect(get_progres)
        QUEST_TYPE.ENHANCE_QUIPMENT:
            EventBus.enhance_a_equipment.connect(get_progres)
    value_changed.emit()

func get_progres(_temp = null) -> void:
    current_value += 1

func can_complete() -> bool:
    if current_value >= need_value:
        return true
    return false

func complete() -> void:
    SoundManager.play_ui_sound(load(Master.POPUP_SOUNDS))
    done = true
    Master.coins += reward_value
