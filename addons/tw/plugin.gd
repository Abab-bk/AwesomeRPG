@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("tw", "res://addons/tw/tw.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("tw")

