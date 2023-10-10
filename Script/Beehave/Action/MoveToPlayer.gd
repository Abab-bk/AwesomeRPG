class_name MoveToPlayer extends ActionLeaf

func tick(actor:Node, blackboard:Blackboard) -> int:
    actor = actor as Enemy
        
    var vision = blackboard.get_value("vision") as VisionComponent
    var atk_range = blackboard.get_value("atk_range") as AtkRangeComponent
    
    if atk_range.target_is_in_range(Master.player):
        return SUCCESS
    
    actor.velocity = actor.global_position.\
    direction_to(Master.player.global_position) * blackboard.get_value("data").speed
    
    if vision.target_is_in_range(Master.player):
        return RUNNING
        
    return FAILURE
