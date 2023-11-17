extends Panel

@onready var icon:TextureRect = %Icon
@onready var name_label:Label = %NameLabel
@onready var cost_label:Label = %CostLabel
@onready var reward_label:Label = %RewardLabel
@onready var enter_btn:Button = %EnterBtn
@onready var un_next_level_btn:Button = %UnNextLevelBtn
@onready var next_level_btn:Button = %NextLevelBtn
@onready var current_level_label:Label = %CurrentLevelLabel

var current_dungeon:DungeonData:
    set(v):
        current_dungeon = v
        if not current_dungeon:
            hide()
        else:
            show()

func _ready() -> void:
    next_level_btn.pressed.connect(func():
        if current_dungeon:
            current_dungeon.next_level()
            update_ui()
        )
    un_next_level_btn.pressed.connect(func():
        if current_dungeon:
            current_dungeon.previous_level()
            update_ui()
        )
    enter_btn.pressed.connect(func():
        if Master.coins < current_dungeon.need_cost:
                EventBus.show_popup.emit("金币不足", "买不起门票啦")
                return
        
        Master.coins -= current_dungeon.need_cost
        EventBus.enter_dungeon.emit(current_dungeon)
        )
    hide()

func update_ui() -> void:
    name_label.text = current_dungeon.name
    cost_label.text = "门票钱：%s" % str(current_dungeon.need_cost)
    match current_dungeon.reward_type:
        "Coins":
            reward_label.text = "奖励： %s 金币" % str(current_dungeon.reward_value)
    
    current_level_label.text = "Lv. %s" % str(current_dungeon.current_level)

func show_dungeon(_data:DungeonData) -> void:
    if current_dungeon == _data:
        return
    
    if current_dungeon:
        current_dungeon.set_level(1)
    
    current_dungeon = _data
    current_dungeon.set_level(1)
    update_ui()

    
