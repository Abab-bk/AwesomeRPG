extends Node

const RED:String = "FF8F87"
const GOLD:String = "F6E9C3"

func make_numbers_to_color(_text:String, _color:String) -> String:
    var _reg:RegEx = RegEx.new()
    
    _reg.compile("^[0-9]*$")
    
    var _search:RegExMatch = _reg.search(_text)
    
    var _result:String = ""
    
    for i in _search.strings:
        _result = _text.replace(i, "[color=%s]%s[/color]" % [_color, i])
    
    print(_result)
    
    return _result

