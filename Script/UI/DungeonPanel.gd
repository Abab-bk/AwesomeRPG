extends Control

@onready var cancel_btn:Button = %CancelBtn
@onready var itmes:VBoxContainer = %Itmes

func _ready() -> void:
    hide()
    cancel_btn.pressed.connect(close)
    for i in Master.dungeons.keys().size():
        var _node = load("res://Scene/UI/DungeonItemUi.tscn").instantiate()
        
        _node.data = Master.get_dungeon_by_id(Master.dungeons[Master.dungeons.keys()[i - 1]].id)
        _node.show_info_panel = %DungeonInfoPanel
        
        itmes.add_child(_node)

func close() -> void:
    var tween:Tween = get_tree().create_tween()
    tween.tween_property($Panel, "global_position", $Panel.global_position + Vector2(0, 1160), 0.2)
    await tween.finished
    hide()

func show_popup() -> void:
    if visible:
        close()
        return
    show()
    
    var tween:Tween = get_tree().create_tween()    
    tween.tween_property($Panel, "global_position", $Panel.global_position - Vector2(0, 1160), 0.2)
    
