@tool
extends EditorPlugin


func _enter_tree() -> void:
    add_autoload_singleton("FlowerLoader", "res://addons/FlowerLoader/FlowerLoader.tscn")

func _exit_tree() -> void:
    remove_autoload_singleton("FlowerLoader")
