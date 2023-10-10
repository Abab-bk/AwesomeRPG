class_name PlayerPatrol extends ActionLeaf

func tick(actor:Node, blackboard:Blackboard) -> int:
    if not actor.closest_enemy:
        actor.find_closest_enemy()
        return RUNNING
    
    actor.velocity = actor.global_position.\
    direction_to(actor.closest_enemy.global_position) * blackboard.get_value("data").speed
    
    return SUCCESS
