@tool
extends EditorPlugin

const attributes_and_abilities_plugin_script = preload("./attributes_and_abilities/plugin.gd")
const turn_based_script = preload("./turn_based/plugin.gd")


var attributes_and_abilities_plugin: EditorPlugin
var turn_based: EditorPlugin


func _init() -> void:
    attributes_and_abilities_plugin = attributes_and_abilities_plugin_script.new()
    turn_based = turn_based_script.new()


func _enter_tree():
    attributes_and_abilities_plugin._enter_tree()
    turn_based._enter_tree()


func _exit_tree():
    attributes_and_abilities_plugin._exit_tree()
    turn_based._exit_tree()
