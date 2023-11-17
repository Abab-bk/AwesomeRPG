extends Control

@onready var itmes:VBoxContainer = %Itmes
@onready var title_bar:MarginContainer = %TitleBar

var close_event:Callable = func():
        var tween:Tween = get_tree().create_tween()
        tween.tween_property($Panel, "global_position", $Panel.global_position + Vector2(0, 1160), 0.2)
        await tween.finished
        hide()

func _ready() -> void:
    hide()
    
    title_bar.cancel_callable = close_event
    
    for i in Master.dungeons.keys().size():
        var _node = load("res://Scene/UI/DungeonItemUi.tscn").instantiate()
        
        _node.data = Master.get_dungeon_by_id(Master.dungeons[Master.dungeons.keys()[i - 1]].id)
        _node.show_info_panel = %DungeonInfoPanel
        
        itmes.add_child(_node)

func show_popup() -> void:
    if visible:
        close_event.call()
        return
    show()
    
    var tween:Tween = get_tree().create_tween()    
    tween.tween_property($Panel, "global_position", $Panel.global_position - Vector2(0, 1160), 0.2)
    
