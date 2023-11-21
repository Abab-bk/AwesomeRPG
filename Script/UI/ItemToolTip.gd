extends Panel

@export var hide_yes_btn:bool = false

@onready var pre_affixe_labels:VBoxContainer = %PreAffixeLabels
@onready var buf_affixe_labels:VBoxContainer = %BufAffixeLabels

@onready var item_color:ColorRect = %ItemColor

@onready var price_label:Label = %PriceLabel
@onready var title_label:Label = %TitleLabel
@onready var rate_label:Label = %RateLabel
@onready var icon:TextureRect = %Icon
@onready var main_buff_label:Label = %MainBuffLabel

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
    EventBus.change_item_tooltip_state.connect(func(_item:InventoryItem, _down:bool = false, _move:bool = false, _display = false):
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
        update_ui())
    
    use_btn.pressed.connect(use)
    
    if hide_yes_btn:
        use_btn.hide()
    
    hide()

func use() -> void:
    match current_state:
        STATE.DOWN:
            EventBus.equipment_down.emit(item.type, item)
        STATE.MOVE:
            EventBus.move_item.emit(item)
        STATE.UP:
            EventBus.equipment_up.emit(item.type, item)
    hide()

func update_ui() -> void:
    title_label.text = item.name
    
    for _affix in pre_affixe_labels.get_children():
        _affix.queue_free()
    
    for _affix in buf_affixe_labels.get_children():
        _affix.queue_free()
    
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
