extends Control

@onready var progress_label:Label = %ProgressLabel
@onready var title_label:Label = %TitleLabel
@onready var reward_label:Label = %RewardLabel
@onready var button:Button = %Button

var current_quest:QuestResource = null:
    set(v):
        current_quest = v
        if not current_quest:
            return
        current_quest.value_changed.connect(update_ui)
        current_quest.connect_signals()

func update_ui() -> void:
    title_label.text = current_quest.name
    reward_label.text = "%s 金币" % current_quest.reward_value
    progress_label.text = "%s / %s" % [str(current_quest.current_value), str(current_quest.need_value)]

func _ready() -> void:
    button.pressed.connect(func():
        if current_quest.can_complete():
            current_quest.complete()
            get_new_quest()
            )
    
    get_new_quest()

func get_new_quest() -> void:
    if not current_quest or current_quest.id == 0:
        current_quest = Master.get_quest_by_id(5001)
        return
    
    if Master.quests.has(current_quest.id + 1):
        current_quest = Master.get_quest_by_id(current_quest.id + 1)
    else:
        pass
