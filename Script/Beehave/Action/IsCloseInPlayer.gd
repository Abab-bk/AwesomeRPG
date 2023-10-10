class_name IsCloseInPlayer extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    
    return SUCCESS
