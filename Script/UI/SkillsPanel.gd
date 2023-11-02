extends Control

@onready var cancel_btn:Button = %CancelBtn
@onready var skills_page:TabContainer = %SkillsPage

@onready var change_skills:Array = [%ChangeSkill1,
%ChangeSkill2,
%ChangeSkill3,
%ChangeSkill4,
%ChangeSkill5,
%ChangeSkill6,
%ChangeSkill7]

func _ready() -> void:
    cancel_btn.pressed.connect(func():
        owner.change_page(owner.PAGE.HOME)
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        
        )
    
    for i in 7:
        var _new_config_panel:VBoxContainer = load("res://Scene/UI/ConfigSkillInfo.tscn").instantiate()
        skills_page.add_child(_new_config_panel)   
 
    for i in change_skills.size():
        change_skills[i].pressed.connect(func():
            skills_page.current_tab = i
            )
