extends Panel

@onready var change_btn:Button = %ChangeBtn

signal changed_ability(id:int)

var parent_id:int = 0
var sub_skill:bool = false
var ability:FlowerAbility = null:
    set(v):
        if not v:
            print_debug(sub_skill)
            %Icon.texture = load("res://icon.svg")
            %NameLabel.text = "未选择技能"
            
            if sub_skill:
                for i in Master.player.config_skills:
                    if ability.id in Master.player.config_skills[i]:
                        var _new_array:Array = Master.player.config_skills[i].duplicate(true)
                        Master.player.config_skills[i].erase(ability.id)
                        _new_array.erase(ability.id)
                        Master.player.ability_container.remove_a_ability_by_id(ability.id)
                        EventBus.sub_ability_changed.emit(i, _new_array)
                        EventBus.player_ability_change.emit()           
            else:
                Master.player.config_skills.erase(ability.id)
                Master.player.ability_container.remove_a_ability_by_id(ability.id)
                EventBus.player_ability_change.emit()
#                Master.player.rebuild_skills()
            
            %DisBtn.hide()
            %ChangeBtn.show()
            
            return
        
        if ability:
            if ability.id in Master.player.config_skills:
                Master.player.config_skills.erase(ability.id)
                Master.player.ability_container.remove_a_ability_by_id(ability.id)
        ability = v
        
        %Icon.texture = load(ability.icon_path)
        %NameLabel.text = ability.name
        %DisBtn.show()
        %ChangeBtn.hide()
        
        changed_ability.emit(ability.id)
        
        if sub_skill:
            EventBus.player_set_a_ability.emit(parent_id, [ability.id])
            return
        
        EventBus.player_set_a_ability.emit(ability.id, [])        

func _ready() -> void:
    change_btn.pressed.connect(func():
        EventBus.show_select_skills_panel.emit(self)
        )
    %DisBtn.pressed.connect(func():
        ability = null
        )
    
    %DisBtn.hide()
    %ChangeBtn.show()
