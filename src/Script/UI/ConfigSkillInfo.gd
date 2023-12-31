extends VBoxContainer

@onready var sub_skills:VBoxContainer = %SubSkills

@export var ui_id:int = 0

func _ready() -> void:
    %MainSkill.changed_ability.connect(func(_ability:FlowerAbility):
        for i in sub_skills.get_children():
            i.parent = _ability
        )
    
    %MainSkill.sub_skill = false
    for i in sub_skills.get_children():
        i.sub_skill = true
