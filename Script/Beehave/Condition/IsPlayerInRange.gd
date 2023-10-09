class_name IsPlayerInRange extends ConditionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    if actor.body_is_in_visiable():
        return SUCCESS
    else:
        return FAILURE
