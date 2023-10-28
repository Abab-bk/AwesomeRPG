class_name InventoryItem extends Resource

@export var name:String = "默认物品"
@export var texture_path:String = "res://icon.svg"
@export var pre_affixs:Array[AffixItem] = []
@export var buf_affix:Array[AffixItem] = []
@export var stackable:bool = false
@export var num:int = 1
@export var type:Const.EQUIPMENT_TYPE
@export var weapon_type:Const.WEAPONS_TYPE = Const.WEAPONS_TYPE.NULL
@export var quality:Const.EQUIPMENT_QUALITY
@export var price:int = 0
