extends Panel

@onready var title_label:Label = %TitleLabel
@onready var value_label:Label = %ValueLabel

@export var title:String
@export var value_index:String

func _ready() -> void:
    EventBus.player_data_change.connect(update_value)
    
    title = self.name
    
    title_label.text = title
    update_value()

func update_value() -> void:
    value_label.text = str(Master.player_output_data[value_index]).pad_decimals(2)
