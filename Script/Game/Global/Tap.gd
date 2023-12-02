extends Node

signal login_ok
signal login_fail
signal login_not

var _plugin_name = "FlowerTapTapSDK"
var _android_plugin

func _ready():
    if Engine.has_singleton(_plugin_name):
        _android_plugin = Engine.get_singleton(_plugin_name)
    else:
        print("Couldn't find plugin " + _plugin_name)


func is_login() -> void:
    if _android_plugin:
        print("检查是否登录")
        _android_plugin.isLogined()
    print("插件初始化失败")
    print(Engine.get_singleton_list())


func login() -> void:
    if _android_plugin:
        print("尝试登录")
        _android_plugin.Login()
    print("插件初始化失败")
    print(Engine.get_singleton_list())
