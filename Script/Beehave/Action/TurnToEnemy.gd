class_name TurnToEnemy extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:   
    if not actor.closest_enemy:
        return FAILURE
    
    actor.look_at(actor.closest_enemy.global_position)
    return SUCCESS
