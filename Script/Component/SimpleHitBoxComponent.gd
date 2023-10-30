class_name SimpleHitBoxComponent extends HitBoxComponent

var damage:float

func _ready() -> void:
    area_entered.connect(handle_damage)

func handle_damage(body:Node) -> void:
    # 主要是匹配玩家
    if disable_target:
        if body.owner == disable_target:
            return
    
    if body is HurtBoxComponent:
        body.handle_hit(damage)
        handled_hit.emit()
