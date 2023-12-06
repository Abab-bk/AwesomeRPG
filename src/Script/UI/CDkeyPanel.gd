extends Control

@onready var title_bar:MarginContainer = %TitleBar
@onready var line_edit:LineEdit = %LineEdit
@onready var yes_btn:Button = %YesBtn

# FIXME: 兑换码兑换装备不会立即出现在背包

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    queue_free()

func _ready() -> void:
    yes_btn.pressed.connect(func():
        if line_edit.text != "":
            apply_reward(decode_str(line_edit.text))
        )
    title_bar.cancel_callable = cancel_event


func apply_reward(_text:String) -> void:
    var _reg:RegEx = RegEx.new()
    _reg.compile("\\[(\\w+)\\]\\[(\\d+)\\]")
    
    if _reg.search(_text) == null:
        EventBus.show_popup.emit("兑换失败", "兑换码错误")
        return
     
    var _result:PackedStringArray = _reg.search(_text).strings
    
    var _reward:Reward = Reward.new()
    @warning_ignore("int_as_enum_without_cast")
    _reward.type = int(_result[1])
    _reward.reward_value = int(_result[2])
    _reward.get_reward()


# 加密字符串
func encode_str(datastr:String,key:String = "") -> String:
    if(key==""):
        key = "027156BFAC4EMH8DIJGLOXPRS9NKTUQV3YWZ"
    var a = key
    var keylen = len(key)
    var strlen = len(datastr)
    var s = ""
    var b
    var b1
    var b2
    var b3
    for i in range(strlen):
        var tb = datastr[i].to_wchar_buffer()
        b = buf_2_u16(tb)
        b1 = b % keylen # 求Unicode编码值得余数
        b = (b - b1) / keylen # 求最大倍数
        b2 = b % keylen # 求最大倍数的于是
        b = (b - b2) / keylen # 求最大倍数
        b3 = b % keylen # 求最大倍数的余数
        s += a[b3] + a[b2] + a[b1] #根据余数值映射到密钥中对应下标位置的字符
    return s  #返回这些映射的字符


# 解密字符串
func decode_str(datastr:String, key:String = "") -> String:
    if(key==""):
        key = "027156BFAC4EMH8DIJGLOXPRS9NKTUQV3YWZ"

    var keylen = len(key);  #获取密钥的长度
    var strlen = len(datastr)
    var b
    var b1
    var b2
    var b3
    var d = 0
    var byteArray:Array = [];  #定义临时变量
    @warning_ignore("integer_division")
    b = floor(strlen / 3);  #获取数组的长度
    for i in range(b):  #//以数组的长度循环次数，遍历加密字符串
        b1 = key.find(datastr[d])  #截取周期内第一个字符串，计算在密钥中的下标值
        d=d+1
        b2 = key.find(datastr[d])  #截取周期内第二个字符串，计算在密钥中的下标值
        d=d+1
        b3 = key.find(datastr[d])  #截取周期内第三个字符串，计算在密钥中的下标值
        d=d+1
        var charCode = b1 * keylen * keylen + b2 * keylen + b3
        if (charCode <= 0x7f) :
            byteArray.append(charCode);
        elif (charCode <= 0x7ff) :
            byteArray.append_array([0xc0 | (charCode >> 6), 0x80 | (charCode & 0x3f)])
        elif (charCode <= 0xffff) :
            byteArray.append_array([0xe0 | (charCode >> 12), 0x80 | ((charCode & 0xfc0) >> 6), 0x80 | (charCode & 0x3f)]);
        else: 
            byteArray.append_array([0xf0 | (charCode >> 18), 0x80 | ((charCode & 0x3f000) >> 12), 0x80 | ((charCode & 0xfc0) >> 6), 0x80 | (charCode & 0x3f)]);
    var s = PackedByteArray(byteArray).get_string_from_utf8()
    return s


func buf_2_u16(arr):
    var _buf = StreamPeerBuffer.new()
    _buf.clear()
    _buf.put_data(arr)
    _buf.seek(0)
    return _buf.get_u16()
