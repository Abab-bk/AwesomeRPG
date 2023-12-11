extends Control

signal creat_ok

@onready var yes_btn:Button = %YesBtn
@onready var line_edit:LineEdit = %LineEdit

@onready var black_rect:ColorRect = $BlackRect
@onready var popup:Panel = $Popup

@onready var title_label:Label = %TitleLabel
@onready var desc_label:RichTextLabel = %DescLabel
@onready var yes_popup_btn:Button = %YesPopupBtn

@onready var dfa:DFA = $DFA as DFA
@onready var http_request:HTTPRequest = $HTTPRequest

var cancel_event:Callable = func():
    hide()


func _ready() -> void:
    %TitleBar.cancel_callable = cancel_event
    
    yes_popup_btn.pressed.connect(hide_popup)
    
    yes_btn.pressed.connect(func():
        if line_edit.text == "":
            return
        
        if line_edit.text.length() > 7:
            show_popup("名字太长", "玩家名最长七个字")
            return
        
        if dfa.is_block_word(line_edit.text.dedent()):
            print("输入：", line_edit.text.dedent())
            show_popup("违禁词", "名称包含违禁词汇，请修改")
            return
        
        #is_block_word(line_edit.text.dedent())
        
        Master.player_name = line_edit.text
        creat_ok.emit()
        )
    
    http_request.request_completed.connect(func(_result:int, _response_code:int, _headers:PackedStringArray, _body:PackedByteArray):
        if _result == OK:
            var _json = JSON.new()
            _json.parse(_body.get_string_from_utf8())
            
            var _response = _json.get_data()
            if _response["num"] == "1":
                show_popup("违禁词", "名称包含违禁词汇，请修改")
                return
            
            Master.player_name = line_edit.text
            creat_ok.emit()
        )
    
    hide_popup()


func is_block_word(_word:String) -> void:
    http_request.request("https://v.api.aa1.cn/api/api-mgc/index.php?msg=%s" % _word)


func show_popup(_title:String, _desc:String) -> void:
    title_label.text = _title
    desc_label.text = """[center]%s[/center]""" % _desc
    black_rect.show()
    popup.show()


func hide_popup() -> void:
    black_rect.hide()
    popup.hide()
