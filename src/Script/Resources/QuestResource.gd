class_name QuestResource extends Resource

signal value_changed

enum QUEST_TYPE {
    KILL_ENEMY,
    ENHANCE_QUIPMENT,
    LEVEL_UP,
    BATTLE_DUNGEON,
    BATTLE_DUNGEON_AND_SUCCESS,
    GACHA,
    CLIMB_TOWER,
    RECYCLE_EQUIPMENT,
    GET_GOLD_EQUIPMENT,
    USE_HP_POTION,
    USE_MP_POTION,
}

@export var id:int = 0
@export var name:String = ""
@export var desc:String = ""
@export var type:QUEST_TYPE = QUEST_TYPE.KILL_ENEMY
@export var reward:Reward
@export var need_value:int = 0
@export var current_value:int = 0:
    set(v):
        current_value = v
        value_changed.emit()
@export var done:bool = false

func connect_signals() -> void:
    match type:
        QUEST_TYPE.KILL_ENEMY:
            if EventBus.is_connected("enemy_die", get_progres):
                return
            EventBus.enemy_die.connect(get_progres)
            
        QUEST_TYPE.LEVEL_UP:
            if EventBus.is_connected("player_level_up", get_progres):
                return
            EventBus.player_level_up.connect(get_progres)
            
        QUEST_TYPE.ENHANCE_QUIPMENT:
            if EventBus.is_connected("enhance_a_equipment", get_progres):
                return
            EventBus.enhance_a_equipment.connect(get_progres)
        
        QUEST_TYPE.BATTLE_DUNGEON:
            if EventBus.is_connected("enter_dungeon", get_progres):
                return
            EventBus.enter_dungeon.connect(get_progres)
            
        QUEST_TYPE.BATTLE_DUNGEON_AND_SUCCESS:
            if EventBus.is_connected("enter_dungeon_and_success", get_progres):
                return
            EventBus.enter_dungeon_and_success.connect(get_progres)
            
        QUEST_TYPE.GACHA:
            if EventBus.is_connected("gacha_pull_1", get_progres):
                return
            EventBus.gacha_pull_1.connect(get_progres)
            
        QUEST_TYPE.CLIMB_TOWER:
            if EventBus.is_connected("start_climb_tower", get_progres):
                return
            EventBus.start_climb_tower.connect(get_progres)
            
            if EventBus.is_connected("go_to_next_tower_level", get_progres):
                return
            EventBus.go_to_next_tower_level.connect(get_progres)
        
        QUEST_TYPE.RECYCLE_EQUIPMENT:
            if EventBus.is_connected("recycle_equipment", get_progres):
                return
            EventBus.recycle_equipment.connect(get_progres)
    
        QUEST_TYPE.GET_GOLD_EQUIPMENT:
            if EventBus.is_connected("player_getd_gold_equipment", get_progres):
                return
            EventBus.player_getd_gold_equipment.connect(get_progres)
    
        QUEST_TYPE.USE_HP_POTION:
            if EventBus.is_connected("use_hp_potion", get_progres):
                return
            EventBus.use_hp_potion.connect(get_progres)
    
        QUEST_TYPE.USE_MP_POTION:
            if EventBus.is_connected("use_mp_potion", get_progres):
                return
            EventBus.use_mp_potion.connect(get_progres)
    
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
    reward.get_reward()
