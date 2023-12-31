extends Control

@onready var skills_page:TabContainer = %SkillsPage

@onready var title_bar:MarginContainer = $Panel/MarginContainer/VBoxContainer/TitleBar

@onready var change_skills:Array = [%ChangeSkill1,
%ChangeSkill2,
%ChangeSkill3,
%ChangeSkill4,
%ChangeSkill5,
%ChangeSkill6,
%ChangeSkill7]

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)

func _ready() -> void:
    title_bar.cancel_callable = cancel_event
    
    # for i in 7:
    #     var _new_config_panel:VBoxContainer = load("res://Scene/UI/ConfigSkillInfo.tscn").instantiate()
    #     skills_page.add_child(_new_config_panel)
 
    for i in change_skills.size():
        change_skills[i].pressed.connect(func():
            skills_page.current_tab = i
            )
