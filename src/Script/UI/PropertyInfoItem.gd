extends Panel

@onready var title_label:Label = %TitleLabel
@onready var value_label:Label = %ValueLabel

@export var title:String
@export var value_index:String
@export var watch_player:bool = true
@export var watch_data:CharacterData:
    set(v):
        watch_data = v
        update_value()

func _ready() -> void:
    if watch_player:
        EventBus.player_data_change.connect(update_value)
    
    title = self.name
    
    title_label.text = title
    update_value()

func update_value() -> void:
    if not visible:
        return
    if watch_player:
        value_label.text = str(Master.player_output_data[value_index]).pad_decimals(2)
        return
    
    if watch_data:
        value_label.text = str(watch_data[value_index]).pad_decimals(2)
