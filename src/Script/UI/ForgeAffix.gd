extends HBoxContainer

@onready var lock_btn:Button = %LockBtn
@onready var desc_label:RichTextLabel = %DescLabel

@onready var icon:TextureRect = $Panel/LockBtn/MarginContainer/Icon

# 拿到的 current_affix 是原来的实例，改变会反映
var current_affix:AffixItem
var forged_affix:AffixItem

var locked:bool = false:
    set(v):
        locked = v
        if locked:
            icon.texture = load("res://Assets/UI/Icons/Lock.svg")
        else:
            icon.texture = load("res://Assets/UI/Icons/UnLock.svg")


func _ready() -> void:
    lock_btn.pressed.connect(func():
        locked = !locked
        )
    update_ui("current_affix")


func random_change_affix() -> void:
    forged_affix = Master.get_random_affix()
    update_ui("forged_affix")


func clean() -> void:
    current_affix = null
    forged_affix = null
    update_ui("current_affix")


func set_null_affix() -> void:
    forged_affix = null
    update_ui("forged_affix")


func update_ui(_key:String) -> void:
    if _key == "current_affix":
        if not current_affix:
            desc_label.text = "空词缀"
            return
        
        desc_label.text = current_affix.desc
    
    if _key == "forged_affix":
        if not forged_affix:
            desc_label.text = "无"
            return
        
        desc_label.text = forged_affix.desc
