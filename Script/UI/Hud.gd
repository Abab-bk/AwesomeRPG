extends CanvasLayer

@onready var hp_bar:ProgressBar = %HpBar
@onready var inventory_btn:Button = %InventoryBtn
@onready var character_btn:Button = %CharacterBtn
@onready var inventory_ui:Control = $Inventory
@onready var character_panel_ui:Control = $CharacterPanel

enum PAGE {
    HOME,
    CHARACTER_PANEL,
    INVENTORY
}

var player_data:CharacterData

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)
    EventBus.new_drop_item.connect(new_drop_item)
    
    inventory_btn.pressed.connect(change_page.bind(PAGE.INVENTORY))
    character_btn.pressed.connect(change_page.bind(PAGE.CHARACTER_PANEL))

    player_data = Master.player.data

    update_ui()

func change_page(_page:PAGE) -> void:
    match _page:
        PAGE.HOME:
            inventory_ui.hide()
            character_panel_ui.hide()
        PAGE.CHARACTER_PANEL:
            inventory_ui.hide()
            character_panel_ui.show()
        PAGE.INVENTORY:
            inventory_ui.show()
            character_panel_ui.hide()

func update_ui() -> void:
    hp_bar.value = (float(player_data.hp) / float(player_data.max_hp)) * 100.0

func new_drop_item(_item:InventoryItem, _pos:Vector2) -> void:
    var _new_sprite:Sprite2D = Sprite2D.new()
    _new_sprite.texture = load(_item.texture_path)
    add_child(_new_sprite)
    
    if _pos.x >= 1080:
        _pos.x = 600
    if _pos.y >= 1920:
        _pos.y = 800
    
    _new_sprite.global_position = _pos
    
    EventBus.add_item.emit(_item)
    EventBus.update_inventory.emit()
    
    await get_tree().create_timer(2.0).timeout
    _new_sprite.queue_free()
