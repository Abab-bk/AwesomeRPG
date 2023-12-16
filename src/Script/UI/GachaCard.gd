extends Control

@onready var icon:TextureRect = %Icon
@onready var title_label:Label = %TitleLabel
@onready var animation_player:AnimationPlayer = %AnimationPlayer

var title:String = ""
var type:Reward.REWARD_TYPE

func _ready() -> void:
    # visibility_changed.connect(try_to_show_animation)

    title_label.text = title
    icon.texture = load(Reward.get_reward_icon_path(type))

func try_to_show_animation() -> void:
    var _tw:Tween = create_tween()
    _tw.tween_method(_change_transition_progress, 0.0, 1.0, 0.4)
    _tw.tween_property($Panel/MarginContainer, "modulate", Color.WHITE, 0.4)
    await _tw.finished
    
    SoundManager.play_ui_sound(load(Master.SOUNDS.Forge))
    
    # if animation_player.is_playing():
    #     return    
    # animation_player.play("run")
    # await animation_player.animation_finished
    # SoundManager.play_ui_sound(load(Master.SOUNDS.Forge))


func _change_transition_progress(_progress:float) -> void:
    $Panel.material.set_shader_parameter("transition_progress", _progress)