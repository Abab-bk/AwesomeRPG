extends Panel

signal change_btn_click
signal data_changed
signal changed(ui_id:int, data:FriendData)

@export var id:int
@export var data:FriendData:
    set(v):
        data = v
        if current_state == 0:
            changed.emit(id, data)
            update_ui()
        else:
            changed.emit(id, null)

@onready var icon:TextureRect = %Icon
@onready var name_label:Label = %NameLabel
@onready var rate_label:Label = %RateLabel

@onready var change_btn:Button = %ChangeBtn
@onready var info_btn:Button = %InfoBtn

# 0是装备，1是卸下
var current_state:int = 0

func _ready() -> void:
    change_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        if current_state == 0:
            change_btn_click.emit()
        else:
            data = null
            update_ui()
        )
    info_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        if not data:
            return
        EventBus.build_and_show_friend_info_panel.emit(data)
        )


func update_ui() -> void:
    if not data:
        name_label.text = "暂无"
        rate_label.text = ""
        icon.texture = load(Const.IMAGES.WhatIcon)
        change_btn.text = "选择"
        current_state = 0
        return
    
    name_label.text = data.name
    rate_label.text = Const.FRIEND_QUALITY.keys()[data.quality]
    icon.texture = load(data.icon_path)
    change_btn.text = "卸下"
    current_state = 1
    
