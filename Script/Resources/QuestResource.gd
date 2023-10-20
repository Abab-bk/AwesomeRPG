class_name QuestResource extends Resource

signal value_changed

enum QUEST_TYPE {
    KILL_ENEMY,
    ENHANCE_QUIPMENT,
    LEVEL_UP,
    NONE,
}

var id:int = 0
var name:String = ""
var desc:String = ""
var type:QUEST_TYPE = QUEST_TYPE.NONE
var reward_value:int = 0
var need_value:int = 0
var current_value:int = 0:
    set(v):
        current_value = v
        value_changed.emit()
var done:bool = false

func connect_signals() -> void:
    match type:
        QUEST_TYPE.KILL_ENEMY:
            EventBus.enemy_die.connect(get_progres)
        QUEST_TYPE.LEVEL_UP:
            EventBus.player_level_up.connect(get_progres)
    value_changed.emit()

func get_progres(_temp = null) -> void:
    current_value += 1

func can_complete() -> bool:
    if current_value >= need_value:
        return true
    return false

func complete() -> void:
    done = true
    Master.coins += reward_value
