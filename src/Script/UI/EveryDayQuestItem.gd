extends Panel

@export var id:String = ""

@onready var title_label:Label = %TitleLabel
@onready var progress_bar_label:Label = %ProgressBarLabel

@onready var progress_bar:ProgressBar = %ProgressBar

@onready var rewards:HBoxContainer = %Rewards

@onready var check_btn:Button = %CheckBtn

@export var current_quest:QuestResource:
    set(v):
        current_quest = v
        current_quest.value_changed.connect(update_ui)
        current_quest.connect_signals()
        update_ui()
        FlowerSaver.set_data("every_day_quest_%s" % id, current_quest)

@onready var content:HBoxContainer = %Content
@onready var complete_label:Label = %CompleteLabel


func _ready() -> void:
    if not current_quest:
        update_quest()
    
    if TimeManager.is_next_day(Master.last_leave_time):
        update_quest()
    
    check_btn.pressed.connect(func():
        if current_quest.can_complete():
            current_quest.complete()
            update_ui()
        )
    
    EventBus.load_save.connect(func():
        current_quest = FlowerSaver.get_data("every_day_quest_%s" % id)
        )
    
    update_ui()


func update_ui() -> void:
    if current_quest.done:
        content.hide()
        complete_label.show()
        return
    
    content.show()
    complete_label.hide()
    title_label.text = current_quest.name
    progress_bar_label.text = "%s / %s" % [str(current_quest.current_value), str(current_quest.need_value)]
    progress_bar.value = (float(current_quest.current_value) / float(current_quest.need_value)) * 100.0


func update_reward_ui() -> void:
    var _new_node = Builder.build_a_reward_item_ui(current_quest.reward) as Panel
    rewards.add_child(_new_node)
    
    _new_node.update_ui(current_quest.reward)


func update_quest() -> void:
    current_quest = Master.get_quest_by_id(Master.quests.keys().pick_random())
    update_reward_ui()
