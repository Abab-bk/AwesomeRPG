extends Node

signal login_ok
signal login_fail
signal login_not
signal init_ok

var _plugin_name = "FlowerTapSDK"
var _android_plugin

var inited:bool = false

func _ready():
    if Engine.has_singleton(_plugin_name):
        _android_plugin = Engine.get_singleton(_plugin_name)
        _android_plugin.logined.connect(func(): login_ok.emit())
        _android_plugin.loginNot.connect(func(): 
            login_not.emit()
            print("未登录")
            )
        _android_plugin.loginFail.connect(func(): login_fail.emit())
        _android_plugin.initOk.connect(func():
            inited = true
            init_ok.emit()
            )
        
    else:
        print("Couldn't find plugin " + _plugin_name)
    #init_plugin()


func is_login() -> void:
    if _android_plugin:
        print("检查是否登录")
        _android_plugin.isLogined()
    
    print("插件初始化失败")
    print(Engine.get_singleton_list())


func init_plugin() -> void:
    if _android_plugin:
        _android_plugin.initPlugin()


func login() -> void:
    if _android_plugin:
        print("尝试登录")
        _android_plugin.Login()
    print("插件初始化失败")
    print(Engine.get_singleton_list())
