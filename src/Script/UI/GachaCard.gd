extends Control

@onready var icon:TextureRect = %Icon
@onready var title_label:Label = %TitleLabel
@onready var animation_player:AnimationPlayer = %AnimationPlayer
@onready var card_img:TextureRect = %CardImg

var title:String = ""
var type:Reward.REWARD_TYPE = Reward.REWARD_TYPE.BOOK_AXE

func _ready() -> void:
    title_label.text = title
    icon.texture = load(Reward.get_reward_icon_path(type))
    if type == Reward.REWARD_TYPE.FRIEND:
        card_img.texture = load("res://Assets/Texture/Images/Cards/RedCard.png")


func try_to_show_animation() -> void:
    Tracer.info("尝试显示抽卡动画，node：%s" % name)
    animation_player.play("turn_card")
    await animation_player.animation_finished

    SoundManager.play_ui_sound(load(Master.SOUNDS.Forge))
    # Tracer.info("抽卡动画播放完成，node：%s" % name)


func turn_over() -> void:
    Tracer.info("翻面，node：%s" % name)
    card_img.texture = load("res://Assets/Texture/Images/Cards/CardFront.png")
