extends AbilityScene

var maxBonus:float = 2.0
var multiper:float = 0.0:
    set(v):
        multiper = min(v, 2.0)

var base_data:CharacterData

func _ready() -> void:
    $Timer.timeout.connect(func():
        queue_free())
    
    var _buff:FlowerBaseBuff = Master.get_buff_by_id(1001)
    actor.flower_buff_manager.add_buff(_buff)
    
    $Timer.start()    
    #base_data = actor.output_data.duplicate(true)
    #multiper = (actor.output_data.max_hp - actor.output_data.hp) / 100
    #
    #actor.output_data.speed = base_data.speed * 1.0 + multiper
    #actor.output_data.speed *= 1.0 + multiper
    #actor.output_data.speed *= 1.0 + multiper
    
    
