extends Node2D

@onready var sprites:Dictionary = {
    "weapon": $Skeleton/bone_004/bone_000/bone_001/Weapon,
    "head": $Skeleton/bone_004/bone_005/Head,
    "body": $Skeleton/bone_004/Body
}

func _ready() -> void:
    EventBus.equipment_up_ok.connect(func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
        match _item.type:
            Const.EQUIPMENT_TYPE.头盔:
                change_head_sprite(load(_item.texture_path))
            Const.EQUIPMENT_TYPE.武器:
                change_weapons_sprite(load(_item.texture_path))
            Const.EQUIPMENT_TYPE.胸甲:
                change_body_sprite(load(_item.texture_path))
        )
    
    EventBus.equipment_down_ok.connect(func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
        match _item.type:
            Const.EQUIPMENT_TYPE.头盔:
                change_head_sprite(load("res://Assets/Characters/Warrior/Head.png"))
            Const.EQUIPMENT_TYPE.武器:
                change_weapons_sprite(load("res://Assets/Characters/Warrior/Weapon.png"))
            Const.EQUIPMENT_TYPE.胸甲:
                change_body_sprite(load("res://Assets/Characters/Warrior/Body.png"))
        )

    EventBus.player_changed_display.connect(func(_data:Dictionary):
        if _data.has("head"):
            change_head_sprite(load(_data.head))
        if _data.has("weapon"):
            change_weapons_sprite(load(_data.weapon))
        if _data.has("body"):
            change_body_sprite(load(_data.body))
        )

func change_weapons_sprite(_sprite:Texture2D) -> void:
    sprites["weapon"].texture = _sprite
    sprites["weapon"].centered = false

func change_head_sprite(_sprite:Texture2D) -> void:
    sprites["head"].texture = _sprite
    sprites["head"].centered = false

func change_body_sprite(_sprite:Texture2D) -> void:
    sprites["body"].texture = _sprite
    sprites["body"].centered = false
