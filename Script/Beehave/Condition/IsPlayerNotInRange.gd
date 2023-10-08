class_name IsPlayerNotInRange extends ConditionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    
    var distance_from_player = actor.get_distance_from_player()
    var enemy_attack_range = actor.get_attack_range()

    if distance_from_player >= enemy_attack_range:
        return SUCCESS
    else:
        return FAILURE
