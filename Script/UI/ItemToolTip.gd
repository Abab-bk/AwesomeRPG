extends Panel

@onready var pre_affixe_labels:VBoxContainer = %PreAffixeLabels
@onready var buf_affixe_labels:VBoxContainer = %BufAffixeLabels

@onready var color:NinePatchRect = %Color

@onready var price_label:Label = %PriceLabel
@onready var title_label:Label = %TitleLabel
@onready var rate_label:Label = %RateLabel

@onready var use_btn:Button = %UseBtn

var item:InventoryItem
var temp_item:InventoryItem = InventoryItem.new()
var down_state:bool

func _ready() -> void:
    EventBus.change_item_tooltip_state.connect(func(_item:InventoryItem, _down:bool = false):
        if _item == null:
            hide()
            return
        
        if _item == item:
            hide()
            item = temp_item
            return
        
        if _down:
            use_btn.text = "卸下"
        else:
            use_btn.text = "装备"
        
        down_state = _down
        
        rate_label.text = ""
        
        match _item.quality:
            Const.EQUIPMENT_QUALITY.NORMAL:
                color.texture = load("res://Assets/UI/Texture/Color4.png")
                rate_label.text += "普通"
            Const.EQUIPMENT_QUALITY.BLUE:
                rate_label.text += "稀有"
                color.texture = load("res://Assets/UI/Texture/Color2.png")
            Const.EQUIPMENT_QUALITY.YELLOW:
                rate_label.text += "魔法"
                color.texture = load("res://Assets/UI/Texture/Color3.png")
            Const.EQUIPMENT_QUALITY.DEEP_YELLO:
                rate_label.text += "传奇"
                color.texture = load("res://Assets/UI/Texture/Color1.png")
            Const.EQUIPMENT_QUALITY.GOLD:
                rate_label.text += "暗金"
                color.texture = load("res://Assets/UI/Texture/Color1.png")
        
        # HACK: 待优化
        rate_label.text += str(Const.EQUIPMENT_TYPE.keys()[_item.type])
        
        price_label.text = "%s $" % str(_item.price)
        
        global_position = get_global_mouse_position()
        # TODO: 计算窗口位置
#        print(DisplayServer.window_get_size())
#        if Vector2i((global_position + size)) > DisplayServer.window_get_size():
#            global_position = global_position - size
        
        item = _item
        show()
        update_ui())
    
    use_btn.pressed.connect(use)
    
    hide()

func use() -> void:
    if down_state:
        EventBus.equipment_down.emit(item.type, item)
        return
    EventBus.equipment_up.emit(item.type, item)

func update_ui() -> void:
    # TODO: 一直实例化成本可能有点高，改成隐藏
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
