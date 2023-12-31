extends Control
# FIXME: 每日任务奖励变了
@onready var items:VBoxContainer = %Items

func _ready() -> void:
    visibility_changed.connect(func():
        if not visible:
            del_all_item()
            return
        Master.update_player_score()
        var player_score:Dictionary = await SilentWolf.Scores.save_score(Master.player_name, Master.player_score).sw_save_score_complete
        Master.player_socre_id = player_score.score_id
        del_all_item()
        update_ui()
        )


func del_all_item() -> void:
    for i in items.get_children():
        i.queue_free()


func update_ui() -> void:
    var sw_result:Dictionary = await SilentWolf.Scores.get_scores(50).sw_get_scores_complete
    
    var _count:int = 0
    for score in sw_result.scores:
        var _node = load("res://Scene/UI/RankingListItem.tscn").instantiate()
        items.add_child(_node)
        _node.player_name = score.player_name
        _node.score = score.score
        _node.rank_sort = _count
        _node.update_ui()
        _count += 1
    
