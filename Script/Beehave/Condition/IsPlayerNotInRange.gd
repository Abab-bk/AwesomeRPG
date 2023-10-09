class_name IsPlayerNotInRange extends ConditionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    
    if actor.body_is_in_visiable():
        return SUCCESS
    else:
        return FAILURE
