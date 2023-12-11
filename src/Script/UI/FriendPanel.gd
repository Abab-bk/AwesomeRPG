extends Panel

@onready var title_bar:MarginContainer = %TitleBar

@export var current_firend_data:CharacterData
@export var current_firend:FriendData:
    set(v):
        current_firend = v
        if current_firend:
            current_firend_data = current_firend.character_data

@onready var up_level_btn:TextureButton = %UpLevelBtn

@onready var memory_btn:Button = %MemoryBtn
@onready var pro_btn:Button = %ProBtn

@onready var popup_yes_btn:Button = %PopupYesBtn
@onready var popup_cancel_btn:Button = %PopupCancelBtn

@onready var rare_label:Label = %RareLabel
@onready var title_label:Label = %TitleLabel

@onready var lv_label:Label = %LvLabel
@onready var xp_level:Label = %XpLevel

@onready var popup_title_label:Label = %PopupTitleLabel
@onready var popup_desc_label:RichTextLabel = %PopupDescLabel

@onready var memory_num_label:Label = %MemoryNumLabel
@onready var memory_signal_img:TextureRect = %MemorySignalImg

@onready var pro_num_label:Label = %ProNumLabel
@onready var pro_signal_img:TextureRect = %ProSignalImg

@onready var property_ui_1:VBoxContainer = %PropertyUI1
@onready var property_ui_2:VBoxContainer = %PropertyUI2

@onready var need_goods_ui:HBoxContainer = %NeedGoodsUI

@onready var popup:Panel = $Popup

@onready var friend_point:Marker2D = %FriendPoint

@onready var level_up_panel:Control = %LevelUpPanel

var current_spend:Array[Array] = [] # [[type, num]]
var current_reward:Callable

var cancel_event:Callable = func():
    save()
    queue_free()


func set_data(_data:FriendData) -> void:
    current_firend = _data
    
    var _new_skin = load("res://Scene/Perfabs/PlayabelCharacter/%s.tscn" % current_firend.skin_name).instantiate()
    friend_point.add_child(_new_skin)
    
    update_propertys_ui_data()
    update_ui()


func _ready() -> void:
    title_bar.cancel_callable = cancel_event
    popup_yes_btn.pressed.connect(confirm_spend)
    popup_cancel_btn.pressed.connect(hide_popup)
    memory_btn.pressed.connect(func():
        show_popup("恢复记忆", "大部分属性大幅提升！", [[Const.MONEY_TYPE.MEMORY, "%s/%s" % [str(current_firend.memory), str(get_memonry_count_by_id(current_firend.id))], 1]])# info [cost_type, cost_desc]
        current_reward = func():
            current_firend_data.set_property_from_const_level(2)
            save()
        save()
        )
    pro_btn.pressed.connect(func():
        show_popup("专精", "提升最大血量、魔法量、敏捷、力量、智慧。", get_pro_need_cost())
        current_reward = func():
            current_firend_data.max_hp += (current_firend_data.max_hp * 0.5)
            current_firend_data.max_magic += (current_firend_data.max_hp * 0.5)
            current_firend_data.agility += (current_firend_data.agility)
            current_firend_data.strength += (current_firend_data.strength)
            current_firend_data.wisdom += (current_firend_data.wisdom)
            save()    
        save()
        )
    
    up_level_btn.pressed.connect(show_level_up_info)
    level_up_panel.cancel.connect(func():
        hide_level_up_info()
        )
    
    hide_popup()
    save()


func get_pro_need_cost() -> Array[Array]:
    var _result:Array[Array] = []
    var _base_cost_coin:int = 20000
    var _base_cost_pole:int = 2
    
    # 金币
    _result.append([Const.MONEY_TYPE.COIN, "%s/%s" % [str(Master.coins), str(_base_cost_coin * current_firend_data.level)], _base_cost_coin * current_firend_data.level])
    # 诗
    _result.append([current_firend.need_pole, "%s/%s" % [str(Master.pole_inventory[current_firend.need_pole]), str(_base_cost_pole * min(current_firend_data.level, 8))], _base_cost_pole * min(current_firend_data.level, 8)])
    # 蓝钱
    _result.append([Const.MONEY_TYPE.MONEY_BLUE, "%s/%s" % [str(Master.moneys["blue"]), str(min(current_firend_data.level * 8, 20))], min(current_firend_data.level * 8, 20)])
    # 白钱
    _result.append([Const.MONEY_TYPE.MONEY_WHITE, "%s/%s" % [str(Master.moneys["white"]), str(min(current_firend_data.level * 8, 20))], min(current_firend_data.level * 8, 20)])
    
    return _result


func get_memonry_count_by_id(_id:int) -> int:
    if Master.memorys.has(_id):
        return Master.memorys[_id].num
    return 0


func get_memonry_by_id(_id:int) -> Memory:
    if Master.memorys.has(_id):
        return Master.memorys[_id]
    return null


func confirm_spend() -> void:
    var _spend_count:int = 0
    
    for _spend_token in current_spend:
        match _spend_token[0]: #type
            Const.MONEY_TYPE.MEMORY:
                if get_memonry_count_by_id(current_firend.id) > 1:
                    var _memory:Memory = get_memonry_by_id(current_firend.id)
                    if not _memory:
                        return
                    
                    _memory.num -= _spend_token[2]
                    if _memory.num <= 0:
                        Master.memorys.erase(current_firend.id)
                        _spend_count += 1
                        
            Const.MONEY_TYPE.XP_BOOK_1:
                if Master.xp_book_inventory[19] < _spend_token[2]: # cost
                    return
                Master.xp_book_inventory[19] -= _spend_token[2]
                _spend_count += 1
                
            Const.MONEY_TYPE.XP_BOOK_2:
                if Master.xp_book_inventory[20] < _spend_token[2]: # cost
                    return
                Master.xp_book_inventory[20] -= _spend_token[2]
                _spend_count += 1
                
            Const.MONEY_TYPE.XP_BOOK_3:
                if Master.xp_book_inventory[21] < _spend_token[2]: # cost
                    return
                Master.xp_book_inventory[21] -= _spend_token[2]
                _spend_count += 1
                
            Const.MONEY_TYPE.XP_BOOK_4:
                if Master.xp_book_inventory[22] < _spend_token[2]: # cost
                    return
                Master.xp_book_inventory[22] -= _spend_token[2]
                _spend_count += 1
    
        if _spend_count == current_spend.size():
            # 花完了，那就是成功
            if not current_reward:
                return
            current_reward.call()


func show_popup(_title:String, _desc:String, _cost_info:Array[Array]) -> void:
    popup_title_label.text = _title
    popup_desc_label.text = "[center]%s[/center]" % _desc
    
    for i in _cost_info:
        need_goods_ui.add_child(build_need_goods_ui_item(i))
    
    popup.show()


# info [cost_type, cost_desc]
func build_need_goods_ui_item(_info:Array) -> Panel:
    var _new_node:Panel = load("res://Scene/UI/ItemArrow.tscn").instantiate()
    
    _new_node.icon_path = Const.get_money_icon_path(_info[0])
    _new_node.desc = _info[1]
    
    return _new_node


func hide_popup() -> void:
    popup.hide()
    
    for i in need_goods_ui.get_children():
        i.queue_free()
    
    current_spend = []
    current_reward = func():pass


func update_propertys_ui_data() -> void:
    for i in property_ui_1.get_children():
        i.watch_data = current_firend_data
    for i in property_ui_2.get_children():
        i.watch_data = current_firend_data


func update_ui() -> void:
    rare_label.text = Const.FRIEND_QUALITY.keys()[current_firend.quality]
    title_label.text = current_firend.name
    lv_label.text = "Lv. %s" % str(current_firend_data.level)
    xp_level.text = "%s/%s" % [str(current_firend_data.now_xp), str(current_firend_data.next_level_xp)]
    
    memory_num_label.text = str(current_firend.memory)
    pro_num_label.text = str(current_firend.pro)

    memory_signal_img.texture = load("res://Assets/UI/Texture/Container/6-%s.png" % str(current_firend.memory))
    pro_signal_img.texture = load("res://Assets/UI/Texture/Container/3-%s.png" % str(current_firend.memory))


func save() -> void:
    FlowerSaver.set_data("master_xp_book_inventory", Master.xp_book_inventory)
    FlowerSaver.set_data("master_pole_inventory", Master.pole_inventory)


func show_level_up_info() -> void:
    level_up_panel.show()
    level_up_panel.friend_data = current_firend_data
    level_up_panel.update_ui()
    update_ui()


func hide_level_up_info() -> void:
    level_up_panel.hide()
    update_ui()
