extends Control

signal item_changed

@onready var item_icon:TextureRect = %ItemIcon

@onready var cancel_btn:Button = %CancelBtn
@onready var select_item_btn:Button = %SelectItemBtn
@onready var forge_btn:Button = %ForgeBtn

@onready var item_name_label:Label = %ItemNameLabel

@onready var pre_affixs:VBoxContainer = %PreAffixs
@onready var buf_affixs:VBoxContainer = %BufAffixs

@onready var origin_tooltip:Panel = %OriginTooltip
@onready var forged_tooltip:Panel = %ForgedTooltip

@onready var tooltips:MarginContainer = %Tooltips
@onready var select_item_panel:MarginContainer = $SelectItem

@onready var cost_1:VBoxContainer = %Cost1
@onready var cost_2:VBoxContainer = %Cost2
@onready var cost_3:VBoxContainer = %Cost3

const FORGE_AFFIX_PATH:String = "res://Scene/UI/ForgeAffix.tscn"

var forged_item:InventoryItem

var cost:Dictionary = {
    "white": 0,
    "blue": 0,
    "purple": 0,
    "yellow": 0
}
# 这个是真原来的实例
var ture_item:InventoryItem
# 现在拿到的并非原来的实例
var current_item:InventoryItem:
    set(v):
        current_item = v
        if not current_item:
            return
        update_cost()
        update_ui()

func update_cost() -> void:    
    cost.white = 0
    cost.blue = 0
    cost.purple = 0
    cost.yellow = 0
    
    if not current_item:
        return
    
    match current_item.quality:
        Const.EQUIPMENT_QUALITY.NORMAL:
            cost.white = 10
            cost.blue = 10
            cost.purple = 10
            cost_1.set_content("白：10")
            cost_2.set_content("蓝：10")
            cost_3.set_content("紫：10")
        Const.EQUIPMENT_QUALITY.BLUE:
            cost.blue = 10
            cost.purple = 10
            cost.yellow = 10
            cost_1.set_content("蓝：10")
            cost_2.set_content("紫：10")
            cost_3.set_content("黄：10")
        Const.EQUIPMENT_QUALITY.YELLOW:
            cost.blue = 500
            cost.purple = 50
            cost.yellow = 50
            cost_1.set_content("蓝：500")
            cost_2.set_content("紫：50")
            cost_3.set_content("黄：50")
        Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
            cost.blue = 5000
            cost.purple = 60
            cost.yellow = 500
            cost_1.set_content("蓝：5000")
            cost_2.set_content("紫：60")
            cost_3.set_content("黄：500")
        Const.EQUIPMENT_QUALITY.GOLD:
            cost.blue = 50000
            cost.purple = 1000
            cost.yellow = 10000
            cost_1.set_content("蓝：50000")
            cost_2.set_content("紫：1000")
            cost_3.set_content("黄：10000")

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
    
    for affix in current_item.pre_affixs:
        var _new_node = load(FORGE_AFFIX_PATH).instantiate()
        _new_node.current_affix = affix
        pre_affixs.add_child(_new_node)
    
    for affix in current_item.buf_affix:
        var _new_node = load(FORGE_AFFIX_PATH).instantiate()
        _new_node.current_affix = affix
        buf_affixs.add_child(_new_node)

func forge() -> void:
    if Master.moneys.white < cost.white:
        return
    if Master.moneys.blue < cost.blue:
        return
    if Master.moneys.purple < cost.purple:
        return
    if Master.moneys.yellow < cost.yellow:
        return
    
    var _pre_affixs:Array[AffixItem] = []
    var _buf_affixs:Array[AffixItem] = []
    
    for affix_node in pre_affixs.get_children():
        if affix_node.locked:
            _pre_affixs.append(affix_node.current_affix)
            continue
        affix_node.random_change_affix()
        _pre_affixs.append(affix_node.forged_affix)
    
    for affix_node in buf_affixs.get_children():
        if affix_node.locked:
            _buf_affixs.append(affix_node.current_affix)
            continue
        affix_node.random_change_affix()
        _buf_affixs.append(affix_node.forged_affix)
    
    forged_item = current_item.duplicate(true) as InventoryItem
    forged_item.pre_affixs = _pre_affixs
    forged_item.buf_affix = _buf_affixs
    
    origin_tooltip.item = current_item
    forged_tooltip.item = forged_item
    
    origin_tooltip.update_ui()
    forged_tooltip.update_ui()

    tooltips.show()
    
    # update_ui()

func accept_forged() -> void:
    if not forged_item:
        return
    
    ture_item.name = forged_item.name
    ture_item.texture_path = forged_item.texture_path
    ture_item.pre_affixs = forged_item.pre_affixs
    ture_item.buf_affix = forged_item.buf_affix
    ture_item.stackable = forged_item.stackable
    ture_item.num = forged_item.num
    ture_item.type = forged_item.type
    ture_item.weapon_type = forged_item.weapon_type
    ture_item.quality = forged_item.quality
    ture_item.price = forged_item.price
    
    forged_item = null


func _ready() -> void:
    cancel_btn.pressed.connect(func():
        hide()
        )
    select_item_btn.pressed.connect(func():
        select_item_panel.show()
        )
    forge_btn.pressed.connect(forge)
    
    select_item_panel.hide()
    tooltips.hide()
    
    update_ui()

