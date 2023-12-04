extends HBoxContainer

@onready var title_label:Label = $TitleLabel
@onready var origin_label:Label = $HBoxContainer/OriginLabel
@onready var new_label:Label = $HBoxContainer/NewLabel


func update_ui(_title:String, _data) -> void:
    if Const.PROPERTY_INFO.has(_title):
        title_label.text = Const.PROPERTY_INFO[_title]
    else:
        title_label.text = _title
    
    origin_label.text = str(_data[0]).pad_decimals(2)
    new_label.text = str(_data[1]).pad_decimals(2)
