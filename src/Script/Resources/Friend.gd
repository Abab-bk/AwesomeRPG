class_name FriendData extends Resource

@export var name:String
@export var id:int
@export var quality:Const.FRIEND_QUALITY
@export var icon_path:String
@export var skin_name:String
@export var character_data:CharacterData
@export var memory:int = 0:
    set(v):
        memory = min(v, 6)
@export var pro:int = 0:
    set(v):
        pro = min(v, 3)
@export var need_pole:Const.MONEY_TYPE = Const.MONEY_TYPE.BOOK_AXE
