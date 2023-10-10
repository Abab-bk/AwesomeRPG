class_name IsEnemyInRange extends ConditionLeaf

func tick(actor:Node, blackboard:Blackboard) -> int:
    if not actor.closest_distance:
        actor.find_closest_enemy()
        return FAILURE
    
    if blackboard.get_value("vision").target_is_in_range(actor.closest_enemy):
        return SUCCESS
    else:
        return FAILURE
