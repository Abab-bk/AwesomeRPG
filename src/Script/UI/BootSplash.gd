extends Control

@onready var login_btn:TextureButton = %LoginBtn

func _ready() -> void:
    $Panel.hide()
    
    Tap.init_ok.connect(func():
        Tap.is_login()
        )
    Tap.login_ok.connect(go_to_world)
    Tap.login_not.connect(func():
        $Panel.show()
        )
    
    login_btn.pressed.connect(func():
        Tap.login()
        )
    
    $AnimationPlayer.play("run")
    await $AnimationPlayer.animation_finished
    $Panel.show()
    
    Tap.is_login()

func go_to_world() -> void:
    get_tree().change_scene_to_packed(load("res://Scene/UI/MainMenu.tscn"))
