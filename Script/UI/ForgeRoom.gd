extends Control

# FIXME: 获得装备会取代第一个背包物品
# TODO: 完善打造装备，余剩：将锻造的装备附加到物品上，与锻造消耗

signal item_changed

@onready var item_icon:TextureRect = %ItemIcon

@onready var cancel_btn:Button = %CancelBtn
@onready var select_item_btn:Button = %SelectItemBtn
@onready var forge_btn:Button = %ForgeBtn

@onready var item_name_label:Label = %ItemNameLabel

@onready var pre_affixs:VBoxContainer = %PreAffixs
@onready var buf_affixs:VBoxContainer = %BufAffixs

@onready var select_item_panel:MarginContainer = $SelectItem

const FORGE_AFFIX_PATH:String = "res://Scene/UI/ForgeAffix.tscn"

var current_item:InventoryItem:
    set(v):
        current_item = v
        if not current_item:
            return
        update_ui()

func update_ui() -> void:    
    for i in pre_affixs.get_children():
        i.queue_free()
    for i in buf_affixs.get_children():
        i.queue_free()
    
    if not current_item:
        print("物品无效")
        return
    
    item_name_label.text = current_item.name
    item_icon.texture = load(current_item.texture_path)
    
    for i in current_item.pre_affixs:
        var _new_node = load(FORGE_AFFIX_PATH).instantiate()
        _new_node.current_affix = i
        pre_affixs.add_child(_new_node)
    for i in current_item.buf_affix:
        var _new_node = load(FORGE_AFFIX_PATH).instantiate()
        _new_node.current_affix = i
        buf_affixs.add_child(_new_node)

func forge() -> void:
    for i in pre_affixs.get_children():
        if i.locked:
            continue
        i.random_change_affix()
    for i in buf_affixs.get_children():
        if i.locked:
            continue
        i.random_change_affix()
    
    # update_ui()

func _ready() -> void:
    cancel_btn.pressed.connect(func():
        hide()
        )
    select_item_btn.pressed.connect(func():
        select_item_panel.show()
        )
    forge_btn.pressed.connect(forge)
    
    update_ui()

