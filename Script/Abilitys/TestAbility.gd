class_name TestAbility extends Ability

func activate(event: ActivationEvent) -> void:
    super.activate(event) 
    
    if not event.character:
        return
    
    print("使用测试技能")

func can_activate(event: ActivationEvent) -> bool:
    var health_attribute = event.get_attribute("health")

    if health_attribute:
        return super.can_activate(event) and health_attribute.current_buffed_value <= 0.0
    else:
        return super.can_activate(event)
