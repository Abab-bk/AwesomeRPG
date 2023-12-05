@tool
extends EditorPlugin

const main_scene := preload("res://addons/flowercdk/Main.tscn")

var _dock:Control

func _enter_tree() -> void:
    _dock = main_scene.instantiate() as Control
    add_control_to_bottom_panel(_dock, "CDK")

func _exit_tree() -> void:
    remove_control_from_bottom_panel(_dock)
    _dock.queue_free()
