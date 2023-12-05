extends Panel

@export var hide_yes_btn:bool = false

@onready var pre_affixe_labels:VBoxContainer = %PreAffixeLabels
@onready var buf_affixe_labels:VBoxContainer = %BufAffixeLabels
@onready var differ_label:VBoxContainer = %DifferLabel

@onready var item_color:ColorRect = %ItemColor

@onready var price_label:Label = %PriceLabel
@onready var title_label:Label = %TitleLabel
@onready var rate_label:Label = %RateLabel
@onready var icon:TextureRect = %Icon
@onready var main_buff_label:RichTextLabel = %MainBuffLabel

@onready var use_btn:Button = %UseBtn

enum STATE {
    MOVE,
    DOWN,
    UP
}

var item:InventoryItem
var temp_item:InventoryItem = InventoryItem.new()
var current_state:STATE = STATE.UP

func _ready() -> void:
    EventBus.change_item_tooltip_state.connect(change_state)
    EventBus.change_tooltip_display_state.connect(func():
        visible = !visible
        )
    
    use_btn.pressed.connect(use)
    
    if hide_yes_btn:
        use_btn.hide()
    
    hide()


func change_state(_item:InventoryItem, _down:bool = false, _move:bool = false, _display = false) -> void:
    if _item == null:
        hide()
        return
    
    if _item == item:
        hide()
        item = temp_item
        return
    
    if _display:
        use_btn.hide()
    
    if _down:
        use_btn.text = "卸下"
        current_state = STATE.DOWN
    else:
        use_btn.text = "装备"
        current_state = STATE.UP
    
    if _move:
        use_btn.text = "移动"
        current_state = STATE.MOVE
    
    rate_label.text = Master.get_rate_text_from_item(_item)
    
    price_label.text = "%s $" % str(_item.price)
    main_buff_label.text = _item.main_buffs.desc
    
    icon.texture = load(_item.texture_path)
    
    global_position = get_global_mouse_position() + Vector2(50, 50)
    
    if Vector2i((global_position + size)).x > get_viewport_rect().size.x:
        global_position.x = global_position.x - size.x
    
    if Vector2i((global_position + size)).y > get_viewport_rect().size.y:
        global_position.y = global_position.y - size.y
    
    item = _item
    show()
    update_ui()


func use() -> void:
    match current_state:
        STATE.DOWN:
            EventBus.equipment_down.emit(item.type, item)
        STATE.MOVE:
            EventBus.move_item.emit(item)
        STATE.UP:
            EventBus.equipment_up.emit(item.type, item)
    hide()

# TODO: 装备对比
func update_ui(_differ:bool = false, _differ_item:InventoryItem = null) -> void:
    title_label.text = item.name
    
    for _affix in pre_affixe_labels.get_children():
        _affix.queue_free()
    
    for _affix in buf_affixe_labels.get_children():
        _affix.queue_free()
    
    for i in differ_label.get_children():
        i.queue_free()
    
    for _affix in item.pre_affixs:
        var _affix_label:HBoxContainer = Builder.build_a_affix_label()
        _affix_label.set_text(_affix.desc)
        pre_affixe_labels.add_child(_affix_label)

    for _affix in item.buf_affix:
        var _affix_label:HBoxContainer = Builder.build_a_affix_label()
        _affix_label.set_text(_affix.desc)
        buf_affixe_labels.add_child(_affix_label)

    if item:
        match item.quality:
            Const.EQUIPMENT_QUALITY.NORMAL:
                item_color.color = Const.COLORS.Normal
            Const.EQUIPMENT_QUALITY.BLUE:
                item_color.color = Const.COLORS.Blue
            Const.EQUIPMENT_QUALITY.YELLOW:
                item_color.color = Const.COLORS.Yellow
            Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
                item_color.color = Const.COLORS.DeepYellow
            Const.EQUIPMENT_QUALITY.GOLD:
                item_color.color = Const.COLORS.Gold
    else:
        item_color.color = Const.COLORS.Normal
    
    if not _differ:
        return

    # 比较物品
    var _item_more:Dictionary = {} #存放 more 计算值，格式：{"hp", 0.14} -> 代表hp + (hp * 0.14%)
    var _item_increase:Dictionary = {} #存放 increasee 计算值，格式：{"hp", 14} -> 代表hp + 14
    var _differ_more:Dictionary = {}
    var _differ_increase:Dictionary = {}
    
    var _final_data:Dictionary = {}
    
    var _item_affixs:Array = item.pre_affixs + item.buf_affix
    var _differ_affixs:Array = _differ_item.pre_affixs + _differ_item.buf_affix
    
    for _item_affix in _item_affixs:
        var _item_compute_data:FlowerComputeData = _item_affix.buff.compute_values[0]
        
        if _item_compute_data.type == FlowerConst.COMPUTE_TYPE.MORE:
            _item_more[_item_compute_data.target_property] = _item_compute_data.value
        elif _item_compute_data.type == FlowerConst.COMPUTE_TYPE.INCREASE:
            _item_increase[_item_compute_data.target_property] = _item_compute_data.value
    
    for _differ_affix in _differ_affixs:
        var _differ_compute_data:FlowerComputeData = _differ_affix.buff.compute_values[0]
            
        if _differ_compute_data.type == FlowerConst.COMPUTE_TYPE.MORE:
            _differ_more[_differ_compute_data.target_property] = _differ_compute_data.value
        elif _differ_compute_data.type == FlowerConst.COMPUTE_TYPE.INCREASE:
            _differ_increase[_differ_compute_data.target_property] = _differ_compute_data.value
    
    # 接下来把_item_more、_item_incrase、_differ_more、_differ_incrase逐一比较处理，然后最终结果赋值给_final_data（_final_data格式：{"对比的属性名称"： 对比结果（以百分数表示）}）
    # 逐一比较处理，计算最终结果
    for _property_name in _item_increase:
        # 拿到了原来的属性
        var _added_value:float = ((_item_increase[_property_name]) / Master.player_output_data[_property_name]) * 100.0
        if _item_more.has(_property_name):
            _item_more[_property_name] = _item_more[_property_name] + _added_value
        else:
            _item_more[_property_name] = _added_value

    for _property_name in _differ_increase:
        # 拿到了原来的属性
        var _added_value:float = ((_differ_increase[_property_name]) / Master.player_output_data[_property_name]) * 100.0
        if _differ_more.has(_property_name):
            _differ_more[_property_name] = _differ_more[_property_name] + _added_value
        else:
            _differ_more[_property_name] = _added_value
    
    for _property_name in _differ_more:
        if _property_name in _item_more:
            if _property_name in _final_data:
                _final_data[_property_name] = _final_data[_property_name] + _differ_more[_property_name] - _item_more[_property_name]
            else:
                _final_data[_property_name] = _differ_more[_property_name] - _item_more[_property_name]
        else:
            if _property_name in _final_data:
                _final_data[_property_name] = _final_data[_property_name] + _differ_more[_property_name]
            else:
                _final_data[_property_name] = _differ_more[_property_name]
    
    # 打印最终结果
    
    #print(_item_more)
    #print(_item_increase)
    #print(_differ_more)
    #print(_differ_increase)
    #print("最终结果", _final_data)
    
    for i in _final_data:
        differ_label.add_child(get_differ_label("%s %s" % [get_chinese_property_text(str(i)), str(_final_data[i])]))
    
    show()
    
    global_position = get_global_mouse_position() + Vector2(50, 50)
    
    if Vector2i((global_position + size)).x > get_viewport_rect().size.x:
        global_position.x = global_position.x - size.x
    
    if Vector2i((global_position + size)).y > get_viewport_rect().size.y:
        global_position.y = global_position.y - size.y


func get_chinese_property_text(_text:String) -> String:
    if Const.PROPERTY_INFO.has(_text):
        return Const.PROPERTY_INFO[_text]
    else:
        return _text


func get_differ_label(_text:String) -> RichTextLabel:
    var _new_label:RichTextLabel = load("res://Scene/UI/DifferLabel.tscn").instantiate()
    _new_label.set_label(_text)
    return _new_label


func handle_affixs_desc(_affix_label:Label, _affix:AffixItem, _differ_item:InventoryItem) -> void:
    for _differ_affix in _differ_item.pre_affixs:
        var _differ_buff_compute_value = _differ_affix.buff.compute_values[0]
            
        if _differ_buff_compute_value.target_property == _affix.buff.compute_values[0].target_property:
            _affix_label.set_text(handle_desc(_affix.desc, SuperComputer.get_differ_in_2_affixs_string(_differ_affix, _affix)))


func handle_desc(_text:String, _handle_string:String = "") -> String:
    return "%s %s" % [_handle_string, _text]
