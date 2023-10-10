class_name IsPlayerInRange extends ConditionLeaf

func tick(_actor:Node, blackboard:Blackboard) -> int:
    if blackboard.get_value("vision").target_is_in_range(Master.player):
        return SUCCESS
    else:
        return FAILURE
