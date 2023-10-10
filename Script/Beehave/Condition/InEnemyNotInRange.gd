class_name IsEnemyNotInRange extends ConditionLeaf

func tick(actor:Node, blackboard:Blackboard) -> int:
    if not actor.closest_enemy:
        actor.find_closest_enemy()
        return FAILURE
    
    if not blackboard.get_value("vision").target_is_in_range(actor.closest_enemy):
        return SUCCESS
    else:
        return FAILURE
