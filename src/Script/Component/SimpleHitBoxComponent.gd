class_name SimpleHitBoxComponent extends HitBoxComponent

func handle_damage(_temp, body:Node, _x, _xx) -> void:
    # 主要是匹配玩家
    if disable_target:
        if body.owner == disable_target:
            return
    
    if body.owner.is_in_group(disable_target_group):
        return
    
    if body is HurtBoxComponent:
        var _damage_data:Dictionary = SuperComputer.handle_damage_dic(damage_data, body.owner.output_data)
        handled_hit.emit(_damage_data.damage, body.owner, _damage_data.crit)
        body.handle_hit(_damage_data.crit, _damage_data.damage)
