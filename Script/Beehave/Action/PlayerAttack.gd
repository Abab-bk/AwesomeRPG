class_name PlayerAttack extends ActionLeaf

var can_attack:bool

func tick(actor:Node, blackboard:Blackboard) -> int:
    actor.velocity = Vector2.ZERO
    
    var weapons:Node2D = blackboard.get_value("weapons") as Weapons
    
    if weapons.attacking:
        return RUNNING
    
    weapons.attack(blackboard.get_value("data").atk_speed)
    
    return SUCCESS
