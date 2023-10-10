class_name EnemyPatrol extends ActionLeaf

func tick(actor:Node, blackboard:Blackboard) -> int:
    actor = actor as Enemy
    actor.velocity = actor.global_position.\
    direction_to(Master.player.global_position) * blackboard.get_value("data").speed
    
    return SUCCESS
