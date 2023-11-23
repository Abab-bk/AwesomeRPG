extends VBoxContainer

@onready var items:GridContainer = %Items

@onready var icon:TextureRect = %Icon
@onready var name_label:Label = %NameLabel
@onready var cost_label:Label = %CostLabel

@onready var buy_btn:Button = %BuyBtn

var ability:FlowerAbility

func _ready() -> void:
    build_store()
    
    buy_btn.pressed.connect(func():
        if not ability:
            return
        
        if Master.coins <= ability.cost:
            EventBus.show_popup.emit("金币不足", "金币不足")
            return
        
        Master.unlocked_skills.append(ability.id)
        Master.coins -= ability.cost
        EventBus.show_popup.emit("购买成功", "购买成功，消耗：%s 金币" % str(ability.cost))
        
        name_label.text = "请选择技能"
        cost_label.text = ""
        buy_btn.hide()
        
        update_ui()        
        )

func update_ui() -> void:
    for i in items.get_children():
        i.queue_free()
    build_store()

func build_store() -> void:
    for i in Master.abilitys:
        if i in Master.unlocked_skills:
            continue
        
        var _btn:TextureRect = Builder.build_a_info_skill_btn()
        _btn.data = Master.get_ability_by_id(i)
        _btn.selected.connect(change_info)
        items.add_child(_btn)

func change_info(_ability:FlowerAbility) -> void:
    icon.texture = load(_ability.icon_path)
    name_label.text = _ability.name
    match _ability.cost_type:
        0:
            cost_label.text = "消耗 %s 生命" % str(_ability.cost_value)
        1:
            cost_label.text = "消耗 %s 魔力" % str(_ability.cost_value)
    
    buy_btn.text = "%s金币 购买" % str(_ability.cost)
    buy_btn.show()
    
    ability = _ability
