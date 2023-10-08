class_name EnemyPatrol extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    actor.patrol()
    
    return SUCCESS
