extends Panel

@onready var all_skills:GridContainer = %AllSkills

@onready var icon:TextureRect = %Icon
@onready var name_label:Label = %NameLabel
@onready var cost_label:Label = %CostLabel
@onready var desc_label:RichTextLabel = %DescLabel

var ability:FlowerAbility
var target_skill_panel:Panel

func _ready() -> void:
    %CancelBtn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        hide()
        queue_free()
        )
    %YesBtn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        
        if Master.coins < 500:
            EventBus.show_popup.emit("金币不足", "金币不足")
            return
        
        Master.coins -= 500
        EventBus.selected_skills_on_panel.emit()
        target_skill_panel.ability = ability
        hide()
        queue_free()
        )
    
    if Master.unlocked_skills.is_empty():
        var _label = Label.new()
        _label.text = "未解锁技能"
        all_skills.add_child(_label)
        return
    
    for i in Master.unlocked_skills:
        if Master.player.ability_container.is_in_container_by_id(i):
            continue
        
        var _skills:FlowerAbility = Master.get_ability_by_id(Master.abilitys[i]["id"])
        
        var _btn:TextureRect = Builder.build_a_info_skill_btn()
        _btn.data = _skills
        all_skills.add_child(_btn)
        
        _btn.selected.connect(func(_data:FlowerAbility):
            ability = _data
            icon.texture = load(ability.icon_path)
            name_label.text = ability.name
            desc_label.text = ability.desc
            match ability.cost_type:
                0:
                    cost_label.text = "消耗 %s 生命" % str(ability.cost_value)
                1:
                    cost_label.text = "消耗 %s 魔力" % str(ability.cost_value)     
            )
