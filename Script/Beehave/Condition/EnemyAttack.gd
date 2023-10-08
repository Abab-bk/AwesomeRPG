class_name EnemyAttack extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    actor.attack()
    
    return SUCCESS
