extends VBoxContainer

@onready var sub_skills:VBoxContainer = %SubSkills

func _ready() -> void:
    %MainSkill.changed_ability.connect(func(_id:int):
        for i in sub_skills.get_children():
            i.parent_id = _id
        )
    
    %MainSkill.sub_skill = false
    for i in sub_skills.get_children():
        i.sub_skill = true
