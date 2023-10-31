extends Panel

@onready var change_btn:Button = %ChangeBtn

signal changed_ability(id:int)

var parent_id:int = 0
var sub_skill:bool = false
var ability:FlowerAbility = null:
    set(v):
        if not v:
            %Icon.texture = load("res://icon.svg")
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
        %ChangeBtn.hide()
        
        # 通过技能面板刷新 sub skill 的 parent
        changed_ability.emit(ability.id)
        
        if sub_skill:
            EventBus.player_set_a_ability.emit(parent_id, [ability.id])
            return
        
        # 真正添加技能到容器
        EventBus.player_set_a_ability.emit(ability, [])        

func _ready() -> void:
    change_btn.pressed.connect(func():
        EventBus.show_select_skills_panel.emit(self)
        )
    %DisBtn.pressed.connect(func():
        ability = null
        )
    
    %DisBtn.hide()
    %ChangeBtn.show()
