@tool
extends EditorPlugin


func _enter_tree() -> void:
    add_autoload_singleton("StringFactory", "res://addons/StringFactory/StringFactory.gd")


func _exit_tree() -> void:
    remove_autoload_singleton("StringFactory")
