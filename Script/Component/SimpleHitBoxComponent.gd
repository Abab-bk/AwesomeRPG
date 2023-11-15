class_name SimpleHitBoxComponent extends HitBoxComponent

func _ready() -> void:
    super()

#func handle_damage(body:Node) -> void:
    ## 主要是匹配玩家
    #if disable_target:
        #if body.owner == disable_target:
            #return
    #
    #if body is HurtBoxComponent:
        #
        #handled_hit.emit(SuperComputer.handle_damage(damage_data, body.owner.output_data), body.owner)
