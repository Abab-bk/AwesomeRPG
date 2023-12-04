extends AbilityScene

@onready var hit_box_component:HitBoxComponent = $HitBoxComponent as HitBoxComponent

func _ready() -> void:
    var _data:CharacterData = CharacterData.new()
    
    _data.fire_damage = randi_range(10, 14)
    
    hit_box_component.damage_data = _data

func timeout() -> void:
    super()
