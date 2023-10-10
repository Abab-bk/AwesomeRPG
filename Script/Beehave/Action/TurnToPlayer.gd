class_name TurnToPlayer extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
    actor.look_at(Master.player.global_position)
    return SUCCESS
