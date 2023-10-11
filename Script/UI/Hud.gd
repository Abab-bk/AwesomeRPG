extends CanvasLayer

@onready var hp_bar:ProgressBar = %HpBar
@onready var inventory:Control = $Inventory
@onready var inventory_btn:Button = %InventoryBtn

var player_data:CharacterData

func _ready() -> void:
    EventBus.update_ui.connect(update_ui)
    EventBus.new_drop_item.connect(new_drop_item)
    
    inventory_btn.pressed.connect(func():inventory.show())

    player_data = Master.player.data

    update_ui()

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
