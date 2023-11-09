extends AbilityScene

var ice_ball := load("res://Scene/Perfabs/Bullets/IceBall.tscn")

func _ready() -> void:
    var _new_ball = ice_ball.instantiate() as IceBall
    
    if actor.velocity == Vector2.ZERO:
        _new_ball.velocity = Vector2(400, 400)
    else:
        _new_ball.velocity = actor.velocity * 3        
    
    # 造成伤害：击中时造成 240% 武器攻击伤害。20% 物理伤害转化为冰冷伤害。
    var _damage_data:CharacterData = CharacterData.new()
    _damage_data.damage = (actor.output_data.weapon_damage * 2.4) * 0.8
    _damage_data.frost_damage = (actor.output_data.weapon_damage * 2.4) * 0.2
    
    add_child(_new_ball)
    
    _new_ball.set_damage_data(_damage_data)
    
    _new_ball.hited_function = func():
        # 击中时造成 120% 武器攻击伤害。该技能 20% 物理伤害转化为冰冷伤害。
        var _damage_data2:CharacterData = CharacterData.new()
        _damage_data2.damage = (actor.output_data.weapon_damage * 1.2) * 0.8
        _damage_data2.frost_damage = (actor.output_data.weapon_damage * 1.2) * 0.2
        
        _new_ball.set_damage_data(_damage_data2)
        _new_ball.add_child(Builder.build_a_sprite_vfx())
        
        for i in _new_ball.get_enemys():
            SuperComputer.handle_damage(actor.output_data, i.output_data)
        
        _new_ball.auto_to_queue_free(5.0)
    
