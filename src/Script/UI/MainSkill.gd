extends Panel

@onready var change_btn:Button = %ChangeBtn
#@onready var auto_use_check_box:CheckBox = %AutoUseCheckBox

signal changed_ability(ability:FlowerAbility)

@export var ui_id:int = 0

var parent:FlowerAbility
var sub_skill:bool = false
var ability:FlowerAbility = null:
    set(v):
        if not v:
            %Icon.texture = load(Const.IMAGES.WhatIcon)
            %NameLabel.text = "未选择技能"
            
            if sub_skill:
                for i in Master.player.config_skills:
                    if ability.id in Master.player.config_skills[i]:
                        var _new_array:Array = Master.player.config_skills[i].duplicate(true)
                        Master.player.config_skills[i].erase(ability.id)
                        _new_array.erase(ability.id)
                        Master.player.ability_container.remove_a_ability(ability)
                        EventBus.sub_ability_changed.emit(i, _new_array)
                        EventBus.player_ability_change.emit()
            else:
                print("卸载技能")
                ability.del_self()
                ability = v
                EventBus.player_ability_change.emit()

            %DisBtn.hide()
            #auto_use_check_box.hide()
            %ChangeBtn.show()
            
            return
        
        if ability:
            # 这里是替换技能
            if ability.id in Master.player.config_skills:
                ability.del_self()
#                Master.player.config_skills.erase(ability.id)
#                Master.player.ability_container.remove_a_ability(ability)
        ability = v
        
        %Icon.texture = load(ability.icon_path)
        %NameLabel.text = ability.name
        %DisBtn.show()
        #auto_use_check_box.show()
        %ChangeBtn.hide()
        
        # 通过技能面板刷新 sub skill 的 parent
        changed_ability.emit(ability)
        
        if sub_skill:
            EventBus.player_set_a_ability.emit(parent, [ability.id])
            return
        
        # 真正添加技能到容器
        EventBus.player_set_a_ability.emit(ability, [])
        FlowerSaver.set_data("main_skill_%s" % str(ui_id + owner.ui_id), {
            "ability": ability,
            "sub_skill": sub_skill,
            "parent": parent
        })

func _ready() -> void:
    EventBus.load_save.connect(func():
        if not FlowerSaver.has_key("main_skill_%s" % str(ui_id + owner.ui_id)):
            return
        
        var _data:Dictionary = FlowerSaver.get_data("main_skill_%s" % str(ui_id + owner.ui_id))
        sub_skill = _data.sub_skill
        parent = _data.parent
        ability = _data.ability
        )

    change_btn.pressed.connect(func():
        EventBus.show_select_skills_panel.emit(self)
        )
    %DisBtn.pressed.connect(func():
        ability = null
        )
    #auto_use_check_box.toggled.connect(func(_state:bool):
        #if _state:
            #
            #return
        #)
    
    
    %DisBtn.hide()
    #auto_use_check_box.hide()
    %ChangeBtn.show()

