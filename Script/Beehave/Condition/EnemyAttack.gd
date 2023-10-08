class_name EnemyAttack extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    
    if actor.can_attack:
        # FIXME: 在success之后直接再次tick，没有攻击间隔
        return RUNNING
    
    actor.attack()
    return SUCCESS
