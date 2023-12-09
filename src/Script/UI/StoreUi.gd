extends Control

@onready var stores:TabContainer = %Stores
@onready var title_bar:MarginContainer = $Panel/MarginContainer/VBoxContainer/TitleBar

@onready var skill_shop_btn:Button = %SkillShopBtn
@onready var money_shop_btn:Button = %MoneyShopBtn

enum PAGE {
    SKILL_STORE,
    SHARD_SHOP
}

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)


func _ready() -> void:
    title_bar.cancel_callable = cancel_event
    
    skill_shop_btn.pressed.connect(change_page.bind(PAGE.SKILL_STORE))
    money_shop_btn.pressed.connect(change_page.bind(PAGE.SHARD_SHOP))
    
    visibility_changed.connect(func():
        if visible:
            for i in stores.get_children():
                i.update_ui()
        )

func change_page(page:PAGE) -> void:
    stores.current_tab = page
