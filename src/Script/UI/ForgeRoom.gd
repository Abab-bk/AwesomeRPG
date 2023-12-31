extends Control

signal item_changed

@onready var item_icon:TextureRect = %ItemIcon

@onready var select_item_btn:Button = %SelectItemBtn
@onready var forge_btn:Button = %ForgeBtn

@onready var item_name_label:Label = %ItemNameLabel
@onready var rate_label:Label = %RateLabel

@onready var pre_affixs:VBoxContainer = %PreAffixs
@onready var buf_affixs:VBoxContainer = %BufAffixs

@onready var origin_tooltip:Panel = %OriginTooltip
@onready var forged_tooltip:Panel = %ForgedTooltip

@onready var tooltips:MarginContainer = %Tooltips
@onready var select_item_panel:MarginContainer = $SelectItem
@onready var title_bar:MarginContainer = $Content/Panel/VBoxContainer/TitleBar

@onready var cost_1:VBoxContainer = %Cost1
@onready var cost_2:VBoxContainer = %Cost2
@onready var cost_3:VBoxContainer = %Cost3

@onready var rename_edit:LineEdit = %RenameEdit

const FORGE_AFFIX_PATH:String = "res://Scene/UI/ForgeAffix.tscn"
const ICON_PATHS = {
    "white": "res://Assets/UI/Icons/MoneyWhite.png",
    "blue": "res://Assets/UI/Icons/MoneyPurple.png",
    "purple": "res://Assets/UI/Icons/MoneyRed.png",
    "yellow": "res://Assets/UI/Icons/MoneyYellow.png",
}

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

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)

func update_cost() -> void:    
    cost.white = 0
    cost.blue = 0
    cost.purple = 0
    cost.yellow = 0
    
    if not current_item:
        return
    
    match current_item.quality:
        Const.EQUIPMENT_QUALITY.NORMAL:
            cost.white = 5 + current_item.forge_count
            cost.blue = 5 + current_item.forge_count
            cost.purple = 5 + current_item.forge_count
            cost_1.set_content("奉献之灰：%s" % str(cost.white), ICON_PATHS.white)
            cost_2.set_content("天堂之尘：%s" % str(cost.blue), ICON_PATHS.blue)
            cost_3.set_content("赦罪之血：：%s" % str(cost.purple), ICON_PATHS.purple)
        Const.EQUIPMENT_QUALITY.BLUE:
            cost.blue = 10 + current_item.forge_count
            cost.purple = 10 + current_item.forge_count
            cost.yellow = 10 + current_item.forge_count
            cost_1.set_content("天堂之尘：%s" % str(cost.blue), ICON_PATHS.blue)
            cost_2.set_content("赦罪之血：%s" % str(cost.purple), ICON_PATHS.purple)
            cost_3.set_content("天使之泪：%s" % str(cost.yellow), ICON_PATHS.yellow)
        Const.EQUIPMENT_QUALITY.YELLOW:
            cost.blue = 10 + current_item.forge_count
            cost.purple = 10 + current_item.forge_count
            cost.yellow = 10 + current_item.forge_count
            cost_1.set_content("天堂之尘：%s" % str(cost.blue), ICON_PATHS.blue)
            cost_2.set_content("赦罪之血：%s" % str(cost.purple), ICON_PATHS.purple)
            cost_3.set_content("天使之泪：%s" % str(cost.yellow), ICON_PATHS.yellow)
        Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
            cost.blue = 10 + current_item.forge_count
            cost.purple = 10 + current_item.forge_count
            cost.yellow = 10 + current_item.forge_count
            cost_1.set_content("天堂之尘：%s" % str(cost.blue), ICON_PATHS.blue)
            cost_2.set_content("赦罪之血：%s" % str(cost.purple), ICON_PATHS.purple)
            cost_3.set_content("天使之泪：%s" % str(cost.yellow), ICON_PATHS.yellow)
        Const.EQUIPMENT_QUALITY.GOLD:
            cost.blue = 10 + current_item.forge_count
            cost.purple = 10 + current_item.forge_count
            cost.yellow = 10 + current_item.forge_count
            cost_1.set_content("天堂之尘：%s" % str(cost.blue), ICON_PATHS.blue)
            cost_2.set_content("赦罪之血：%s" % str(cost.purple), ICON_PATHS.purple)
            cost_3.set_content("天使之泪：%s" % str(cost.yellow), ICON_PATHS.yellow)

func update_ui() -> void:    
    for i in pre_affixs.get_children():
        i.queue_free()
    for i in buf_affixs.get_children():
        i.queue_free()
    
    if not current_item:
        item_name_label.text = "选择装备"
        rate_label.text = ""
        item_icon.texture = null
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
    
    rate_label.text = Master.get_rate_text_from_item(current_item)

func forge() -> void:
    if not current_item:
        return
    
    if not ture_item:
        return
    
    if not OS.get_name() == "Windows":
        if Master.moneys.white < cost.white:
            EventBus.new_tips.emit("货币不足")
            return
        if Master.moneys.blue < cost.blue:
            EventBus.new_tips.emit("货币不足")
            return
        if Master.moneys.purple < cost.purple:
            EventBus.new_tips.emit("货币不足")
            return
        if Master.moneys.yellow < cost.yellow:
            EventBus.new_tips.emit("货币不足")
            return
        
        Master.moneys.white -= cost.white
        Master.moneys.blue -= cost.blue
        Master.moneys.purple -= cost.purple
        Master.moneys.yellow -= cost.yellow
        
    var _pre_affixs:Array[AffixItem] = []
    var _buf_affixs:Array[AffixItem] = []
    
    forged_item = current_item.duplicate(true) as InventoryItem    
    
    for affix_node in pre_affixs.get_children():
        if affix_node.locked:
            _pre_affixs.append(affix_node.current_affix)
            continue
        
        var _should_forge:bool = [true, false].pick_random()
        if not _should_forge:
            affix_node.set_null_affix()
            continue

        affix_node.random_change_affix(forged_item.forge_count / 5.0)
        _pre_affixs.append(affix_node.forged_affix)
    
    for affix_node in buf_affixs.get_children():
        if affix_node.locked:
            _buf_affixs.append(float(forged_item.forge_count / 5.0))
            continue

        var _should_forge:bool = [true, false].pick_random()
        if not _should_forge:
            affix_node.set_null_affix()
            continue
        
        affix_node.random_change_affix(float(forged_item.forge_count))
        _buf_affixs.append(affix_node.forged_affix)
    
    forged_item.forge_count += 1
    forged_item.pre_affixs = _pre_affixs
    forged_item.buf_affix = _buf_affixs
    
    if rename_edit.text != "":
        forged_item.name = rename_edit.text
    
    origin_tooltip.item = current_item
    forged_tooltip.item = forged_item
    
    origin_tooltip.update_ui()
    forged_tooltip.update_ui()
    
    tooltips.show()
    
    SoundManager.play_ui_sound(load(Master.SOUNDS.Forge))
    
    EventBus.enhance_a_equipment.emit()
    
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
    ture_item.ranged_weapon_type = forged_item.ranged_weapon_type
    ture_item.quality = forged_item.quality
    ture_item.price = forged_item.price
    ture_item.main_buffs = forged_item.main_buffs.duplicate(true)
    ture_item.forge_count = forged_item.forge_count
    
    current_item = ture_item.duplicate(true)
    
    forged_item = null


func _ready() -> void:
    select_item_btn.pressed.connect(func():
        select_item_panel.show()
        )
    visibility_changed.connect(func():
        current_item = null
        ture_item = null
        update_ui()
        )
    forge_btn.pressed.connect(forge)
    
    title_bar.cancel_callable = cancel_event
    
    select_item_panel.hide()
    tooltips.hide()
    
    update_ui()

