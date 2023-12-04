extends CanvasLayer

@onready var label:Label = %Label
@onready var progress_bar:ProgressBar = %ProgressBar

func _ready() -> void:
    hide()

func change_scene(_home_scene, _scene_path:String) -> void:
    show()
    var _target_scene = load(_scene_path).instantiate()
    
    _home_scene.queue_free()
    get_tree().root.add_child(_target_scene)
    
    hide()
