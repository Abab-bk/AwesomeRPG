class_name EnemyPatrol extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor = actor as Enemy
    actor.velocity = Vector2(randi_range(-100, 200), randi_range(-100, 200)) * actor.get_speed()
    
    return SUCCESS
