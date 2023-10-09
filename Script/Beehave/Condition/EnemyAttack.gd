class_name EnemyAttack extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    
    if actor.can_attack:
        return RUNNING
    
    actor.attack()
    return SUCCESS
