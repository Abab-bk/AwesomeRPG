class_name MoveToPlayer extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    
    actor.velocity = actor.global_position.direction_to(Master.player.global_position) * actor.get_speed()
    
    return SUCCESS
