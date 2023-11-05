extends Panel

@onready var lock_btn:Button = %LockBtn
@onready var desc_label:Label = %DescLabel

var current_affix:AffixItem
var forged_affix:AffixItem

var locked:bool = false:
    set(v):
        locked = v
        if locked:
            lock_btn.text = "解锁"
        else:
            lock_btn.text = "锁定"

func _ready() -> void:
    lock_btn.pressed.connect(func():
        locked = !locked
        )
    update_ui("current_affix")

func random_change_affix() -> void:
    forged_affix = Master.get_random_affix()
    update_ui("forged_affix")

func update_ui(_key:String) -> void:
    if _key == "current_affix":
        if not current_affix:
            return
        desc_label.text = current_affix.desc
    if _key == "forged_affix":
        if not forged_affix:
            print("forgeed_affix无效")
            return
        print("forged_affix有效：", forged_affix.desc)
        desc_label.text = forged_affix.desc
        print("desc_label：", forged_affix.desc)
