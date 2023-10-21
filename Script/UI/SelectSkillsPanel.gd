extends Panel

@onready var all_skills:GridContainer = %AllSkills

@onready var icon:TextureRect = %Icon
@onready var name_label:Label = %NameLabel
@onready var mp_label:Label = %MpLabel
@onready var desc_label:RichTextLabel = %DescLabel

# TODO: 待完善技能配置面板

func _ready() -> void:
    %CancelBtn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        hide()
        queue_free()
        )
    %YesBtn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        hide()
        queue_free()
        )
    
    for i in Master.unlocked_skills:
        var _skills:FlowerAbility = FlowerAbility.new()
        _skills.icon_path = Master.abilitys[i]["icon_path"]
        _skills.name = Master.abilitys[i]["name"]
        _skills.desc = Master.abilitys[i]["name"]
        
        var _btn:TextureRect = Builder.build_a_info_skill_btn()
        _btn.data = _skills
        all_skills.add_child(_btn)
        
        _btn.selected.connect(func(_data:FlowerAbility):
            icon.texture = load(_data.icon_path)
            name_label.text = _data.name
            desc_label.text = _data.desc
            )
