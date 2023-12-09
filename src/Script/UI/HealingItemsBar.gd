extends HBoxContainer

@onready var hp_potion:Button = %HpPotion
@onready var magic_potion:Button = %MagicPotion

@onready var hp_potion_num_label:Label = %HpPotionNumLabel
@onready var mp_potion_num_label:Label = %MpPotionNumLabel

func _ready() -> void:
    hp_potion.pressed.connect(func():
        if not Master.player_healing_items.hp_potion > 0:
            return
        Master.player_output_data.hp += 200
        Master.player_healing_items.hp_potion -= 1
        
        EventBus.use_hp_potion.emit()
        
        update_ui()
        )
    magic_potion.pressed.connect(func():
        if not Master.player_healing_items.mp_potion > 0:
            return
        Master.player_output_data.magic += 200
        Master.player_healing_items.mp_potion -= 1
        
        EventBus.use_mp_potion.emit()
        
        update_ui()
        )
    EventBus.player_get_healing_potion.connect(func(_x, _xx):
        update_ui()
        )
    
    update_ui()

func update_ui() -> void:
    hp_potion_num_label.text = str(Master.player_healing_items.hp_potion)
    mp_potion_num_label.text = str(Master.player_healing_items.mp_potion)
    EventBus.update_ui.emit()
