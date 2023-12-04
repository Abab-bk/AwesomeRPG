extends Area2D

func _ready() -> void:
    body_entered.connect(func(_body:Node2D):
        if _body is Enemy:
            _body.queue_free()
            return
        
        if _body is Player:
            _body.relife()
            return
        )
