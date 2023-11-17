extends Node2D

@export var icon_max_size:Vector2 = Vector2(128, 128)

var item:InventoryItem

func set_item(_item:InventoryItem) -> void:
    item = _item
    
    $Sprite2D.texture = load(_item.texture_path)
    
    match _item.quality:
        Const.EQUIPMENT_QUALITY.NORMAL:
            $ColorRect.color = Const.COLORS.Normal
        Const.EQUIPMENT_QUALITY.BLUE:
            $ColorRect.color = Const.COLORS.Blue
        Const.EQUIPMENT_QUALITY.YELLOW:
            $ColorRect.color = Const.COLORS.Yellow
        Const.EQUIPMENT_QUALITY.DEEP_YELLOW:
            $ColorRect.color = Const.COLORS.DeepYellow
        Const.EQUIPMENT_QUALITY.GOLD:
            $ColorRect.color = Const.COLORS.Gold
    
    $ColorRect/Label.text = _item.name
    $ColorRect/Label.set("theme_override_colors/font_color", Color(1.0 - $ColorRect.color.r, 1.0 - $ColorRect.color.g, 1.0 - $ColorRect.color.b))

func _ready() -> void:
    $Button.pressed.connect(get_item)
    Master.occupied_positions.append(global_position)
    
    $Sprite2D.scale.x = icon_max_size.x / $Sprite2D.texture.get_width()
    $Sprite2D.scale.y = icon_max_size.y / $Sprite2D.texture.get_height()
    
    var tween:Tween = get_tree().create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(188, -94), 0.2)
    tween.tween_property(self, "global_position", global_position + Vector2(366, 0), 0.2)
    await tween.finished
    
    await get_tree().create_timer(1.0).timeout
    get_item()
    
    queue_free()
    
func get_item() -> void:
    Master.occupied_positions.erase(global_position)
    EventBus.add_item.emit(item)
    queue_free()
