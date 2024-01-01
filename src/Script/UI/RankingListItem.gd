extends Panel

@export var player_name:String = ""
@export var score:int = 0
@export var rank_sort:int = 0
@export var is_self:bool
@export var is_player:bool = false

@onready var rank_label:Label = %RankLabel
@onready var player_name_label:Label = %PlayerNameLabel
@onready var player_power_label:Label = %PlayerPowerLabel


func _ready() -> void:
    Master.update_player_score()
    visibility_changed.connect(func():
        if visible and is_player:
            score = Master.player_score
            player_name = Master.player_name
            rank_label.hide()
            update_ui()
        )


func update_ui() -> void:
    rank_label.text = "#%s" % str(rank_sort)
    player_name_label.text = player_name
    player_power_label.text = "战力：%s" % str(score)
