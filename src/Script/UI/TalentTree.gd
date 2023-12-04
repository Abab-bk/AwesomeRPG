extends Control

@onready var camera:Camera2D = $Camera2D
@onready var worldmap_view:WorldmapView = %WorldmapView
@onready var root_item:WorldmapGraph = %RootItem

func _input(event:InputEvent) -> void:
    if event is InputEventMouseMotion:
        if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
            camera.position -= event.relative * camera.zoom
