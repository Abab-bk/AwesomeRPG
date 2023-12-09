extends Panel

@export var hide_yes_btn:bool = false
@export var target_differ_item:Panel
@export var differed_item:bool = false

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
    if differed_item:
        use_btn.hide()
        hide()
        return
    
    EventBus.change_item_tooltip_state.connect(change_state)
    
    EventBus.change_tooltip_display_state.connect(func():
        visible = !visible
        )
    
    use_btn.pressed.connect(use)
    
    if hide_yes_btn:
        use_btn.hide()
    
    hide()


func change_state(_item:InventoryItem, _down:bool = false, _move:bool = false, _display = false, _differ:bool = false, _differ_item:InventoryItem = null) -> void:
    if _item == null:
        hide()
        if target_differ_item:
            target_differ_item.hide()
        #Tracer.info("Tooltip 的 Item 为 null：%s" % name)
        return
    
    if _item == item:
        hide()
        if target_differ_item:
            target_differ_item.hide()
        #Tracer.info("Tooltip 的 Item 相等：%s" % name)
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
        
    global_position = get_global_mouse_position() + Vector2(50, 50)
    
    if Vector2i((global_position + size)).x > get_viewport_rect().size.x:
        global_position.x = global_position.x - size.x
    
    if Vector2i((global_position + size)).y > get_viewport_rect().size.y:
        global_position.y = global_position.y - size.y
    
    item = _item
    show()
    
    if _differ and target_differ_item:
        target_differ_item.show()
        target_differ_item.item = _differ_item
        target_differ_item.update_ui()
        update_ui(_differ)
    else:
        update_ui()        

func use() -> void:
    match current_state:
        STATE.DOWN:
            EventBus.equipment_down.emit(item.type, item, true)
        STATE.MOVE:
            EventBus.move_item.emit(item)
        STATE.UP:
            EventBus.equipment_up.emit(item.type, item)
    hide()

# TODO: 装备对比
func update_ui(_differ:bool = false) -> void:
    title_label.text = item.name
    rate_label.text = Master.get_rate_text_from_item(item)    
    
    price_label.text = "%s $" % str(item.price)
    main_buff_label.text = item.main_buffs.desc
    icon.texture = load(item.texture_path)
    
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
    
    show()
    
    if _differ:
        global_position = get_global_mouse_position() + Vector2(50, 50)
        global_position.y += size.y
    else:
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
