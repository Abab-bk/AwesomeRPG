extends RichTextLabel

func set_label(_text:String) -> void:
    if float(_text) > 0:
        _text = "[color=%s]+ %s[/color]" % ["#F6E9C3", _text]
    else:
        _text = "[color=%s]- %s[/color]" % ["#F6E9C3", _text]
    text = _text.pad_decimals(1)
