extends Control

var dialogue_resource:DialogueResource = load("res://Assets/Dialogues/Start.dialogue")

func _ready() -> void:
    DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
    EventBus.dialogue_ok.connect(func(_key:String):
        if _key == "Start":
            get_tree().change_scene_to_packed(load("res://Scene/World.tscn")))
