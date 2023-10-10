class_name MoveToEnemy extends ActionLeaf

func tick(actor:Node, blackboard:Blackboard) -> int:        
    var vision = blackboard.get_value("vision") as VisionComponent
    var atk_range = blackboard.get_value("atk_range") as AtkRangeComponent
    
    if atk_range.target_is_in_range(actor.closest_enemy):
        return SUCCESS
    
    actor.velocity = actor.global_position.\
    direction_to(actor.closest_enemy.global_position) * blackboard.get_value("data").speed
    
    if vision.target_is_in_range(actor.closest_enemy):
        return RUNNING
        
    return FAILURE
