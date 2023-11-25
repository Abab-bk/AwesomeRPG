extends HBoxContainer

func set_text(_v:String) -> void:
    $Label.text = _v #StringFactory.make_numbers_to_color(_v, StringFactory.GOLD)
