extends Control

@onready var itmes:VBoxContainer = %Itmes
@onready var title_bar:MarginContainer = %TitleBar

var close_event:Callable = func():
        owner.change_page(0)
        hide()


func _ready() -> void:
    hide()
    
    title_bar.cancel_callable = close_event
    
    for key in Master.dungeons.keys():
        var _node = load("res://Scene/UI/DungeonItemUi.tscn").instantiate()
        
        _node.data = Master.get_dungeon_by_id(Master.dungeons[key].id)
        _node.show_info_panel = %DungeonInfoPanel
        
        itmes.add_child(_node)


func show_popup() -> void:
    if visible:
        close_event.call()
        return
    show()
    
