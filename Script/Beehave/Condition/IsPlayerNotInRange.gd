class_name IsPlayerNotInRange extends ConditionLeaf

func tick(_actor:Node, blackboard:Blackboard) -> int:
    if blackboard.get_value("vision").target_is_in_range(Master.player):
        return FAILURE
    else:
        return SUCCESS
