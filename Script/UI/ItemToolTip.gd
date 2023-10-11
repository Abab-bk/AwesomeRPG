extends Panel

@onready var affixe_labels:VBoxContainer = %AffixeLabels
@onready var title_label:Label = %TitleLabel

var item:InventoryItem

func _ready() -> void:
    EventBus.show_item_tooltip.connect(func(_item:InventoryItem, pos:Vector2):
        global_position = pos
        item = _item
        show()
        update_ui()
        )
    hide()

func update_ui() -> void:
    title_label.text = item.name
    
    for _affix in affixe_labels.get_children():
        _affix.queue_free()
    
    for _affix in item.affixs:
        var _affix_label:Label = Label.new()
        _affix_label.add_theme_font_size_override("font_size", 30)
        _affix_label.text = _affix.desc
        affixe_labels.add_child(_affix_label)
