extends Control

@onready var progress_label:Label = %ProgressLabel
@onready var title_label:Label = %TitleLabel
@onready var reward_label:Label = %RewardLabel
@onready var button:Button = %Button

@export var current_quest:QuestResource = null:
    set(v):
        current_quest = v
        FlowerSaver.set_data("quest_current_quest", current_quest)
        
        if not current_quest:
            return
        if current_quest.is_connected("value_changed", update_ui):
            return
        
        current_quest.value_changed.connect(update_ui)
        current_quest.connect_signals()


func update_ui() -> void:
    title_label.text = current_quest.name
    
    if current_quest.reward:
        reward_label.text = "%s %s" % [str(current_quest.reward.reward_value), str(Reward.get_string(current_quest.reward.type))]
        progress_label.text = "%s / %s" % [str(current_quest.current_value), str(current_quest.need_value)]


func _ready() -> void:
    button.pressed.connect(func():
        if current_quest.can_complete():
            current_quest.complete()
            get_new_quest()
            )
    
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("flyed_just_now"):
            if FlowerSaver.get_data("flyed_just_now") == true:
                return
        
        current_quest = FlowerSaver.get_data("quest_current_quest")
        update_ui()
        )
    
    get_new_quest()


func get_new_quest() -> void:
    if not current_quest or current_quest.id == 0:
        current_quest = Master.get_quest_by_id(5001)
        return
    
    if Master.quests.has(current_quest.id + 1):
        current_quest = Master.get_quest_by_id(current_quest.id + 1)
