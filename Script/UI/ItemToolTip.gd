extends Panel

@onready var affixe_labels:VBoxContainer = %AffixeLabels
@onready var title_label:Label = %TitleLabel
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
        
        global_position = get_global_mouse_position() + Vector2(50, 50)
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
    
    for _affix in affixe_labels.get_children():
        _affix.queue_free()
    
    for _affix in item.affixs:
        var _affix_label:Label = Label.new()
        _affix_label.add_theme_font_size_override("font_size", 30)
        _affix_label.text = _affix.desc
        affixe_labels.add_child(_affix_label)
