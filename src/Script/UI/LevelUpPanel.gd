extends Control

signal cancel

@export var friend_data:CharacterData

@onready var yes_btn:Button = %YesBtn
@onready var cancel_btn:Button = %CancelBtn

@onready var need_goods_ui:HBoxContainer = %NeedGoodsUI

@onready var min_label:Label = %MinLabel
@onready var max_label:Label = %MaxLabel
@onready var h_slider:HSlider = %HSlider

@onready var level_label:Label = %LevelLabel
@onready var progress_bar:ProgressBar = %ProgressBar
@onready var slider_content:MarginContainer = %SliderContent

var current_select:int = Const.MONEY_TYPE.NONE
var sim_all_xp:float = 0

var offset:int = 0

var simed:bool = false
var _current_level:int = 0
var _next_level_xp:float = 0

func _ready() -> void:
    slider_content.hide()
    h_slider.value_changed.connect(func(_value:float):
        offset = 0
        if current_select == Const.MONEY_TYPE.NONE:
            return
        sim_all_xp = get_geted_xp_by_type(current_select) * int(h_slider.value)
        sim_get_xp()
        )
    
    yes_btn.pressed.connect(func():
        Master.xp_book_inventory[current_select] -= h_slider.value
        var _get_all_xp:int = 0
        sim_all_xp = 0
        simed = false
            
        _get_all_xp = get_geted_xp_by_type(current_select) * int(h_slider.value)
        
        while true:
            _next_level_xp = (15 + ((friend_data.level + 1) ** 3)) * (1.07 ** friend_data.level)
            
            if friend_data.now_xp + _get_all_xp < _next_level_xp:
                break
            
            friend_data.level_up()
            
            level_label.text = "Lv. %s" % str(_current_level)
        
        update_ui()
        )
    
    cancel_btn.pressed.connect(func():
        cancel.emit()
        )
    
    update_ui()

func get_geted_xp_by_type(_type:Const.MONEY_TYPE) -> int:
    match _type:
        Const.MONEY_TYPE.XP_BOOK_1:
            return 200
        Const.MONEY_TYPE.XP_BOOK_2:
            return 400
        Const.MONEY_TYPE.XP_BOOK_3:
            return 600
        Const.MONEY_TYPE.XP_BOOK_4:
            return 800
    return 0


func _physics_process(_delta:float) -> void:
    if friend_data:
        if simed:
            progress_bar.value = (friend_data.now_xp + sim_all_xp / _next_level_xp) * 100.0
            return
        progress_bar.value = (friend_data.now_xp / friend_data.next_level_xp) * 100.0


func update_ui() -> void:
    if not friend_data:
        return
    
    level_label.text = "Lv. %s" % str(friend_data.level)
    
    for i in need_goods_ui.get_children():
        i.queue_free()
    
    for i in Master.xp_book_inventory:
        var _new_node = load("res://Scene/UI/ItemArrow.tscn").instantiate()
        _new_node.icon_path = Const.get_money_icon_path(i)
        _new_node.desc = str(Master.xp_book_inventory[i])
        need_goods_ui.add_child(_new_node)
        _new_node.id = i
        
        _new_node.pressed.connect(func():
            current_select = _new_node.id
            update_slider(Master.xp_book_inventory[i])
            )


func sim_get_xp(_offset:int = 0) -> void:
    simed = true
    _current_level = friend_data.level + _offset
    _next_level_xp = (15 + ((_current_level + 1) ** 3)) * (1.07 ** _current_level)
    
    if friend_data.now_xp + sim_all_xp < _next_level_xp:
        return  
    
    level_label.text = "Lv. %s" % str(_current_level)
    
    offset += 1
    sim_get_xp(offset)


func update_slider(_max_value) -> void:
    if _max_value == 0:
        slider_content.hide()
        return
    
    slider_content.show()
    h_slider.min_value = 1
    h_slider.max_value = _max_value
