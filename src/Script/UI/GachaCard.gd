extends Control

@onready var icon:TextureRect = %Icon
@onready var title_label:Label = %TitleLabel
@onready var animation_player:AnimationPlayer = %AnimationPlayer

var title:String = ""
var type:Reward.REWARD_TYPE

func _ready() -> void:
    title_label.text = title
    icon.texture = load(Reward.get_reward_icon_path(type))
