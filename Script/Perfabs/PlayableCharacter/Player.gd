extends CharacterBody2D

@onready var flower_buff_manager:FlowerBuffManager = $FlowerBuffManager
@onready var animation_player:AnimationPlayer = $AnimationPlayer

var data:CharacterData
var target:Vector2 = global_position

var closest_distance:float = 1000000
var closest_enemy:Enemy
var all_enemy:Array

func _ready() -> void:
    Master.player = self
    EventBus.player_dead.connect(relife)
    EventBus.enemy_die.connect(find_closest_enemy)
    EventBus.equipment_up.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
        # 判断插槽有没有
        
        # 装备
        # TODO: 如果 type 是武器或者项链，选择左右手，当前为直接替换
        data.quipments[_type] = _item
        
        # TODO: 实现装备，已实现buff加成
        
        # 应用 Buff
        for i in _item.affixs:
            flower_buff_manager.add_buff(i.buff)
            flower_buff_manager.compute()
        
        # 更新 UI
        EventBus.equipment_up_ok.emit(_type, _item)
        )
    
    EventBus.equipment_down.connect(
        func(_type:Const.EQUIPMENT_TYPE, _item:InventoryItem):
            data.quipments[_type] = null
            
            for i in _item.affixs:
                print("移除装备")
                flower_buff_manager.remove_buff(i.buff)
                # TODO: 更新后无需手动调用 compute
                flower_buff_manager.compute()
            
            EventBus.equipment_down_ok.emit(_type, _item)
            )
    
    data = flower_buff_manager.compute_data

func _physics_process(_delta: float) -> void:
    move_and_slide()

func relife() -> void:
    # FIXME: data是资源，不会唯一化
    data.hp = data.max_hp
    global_position = Master.relife_point.global_position
    animation_player.play_backwards("Die")
    await animation_player.animation_finished

func die() -> void:
    animation_player.play("Die")
    await animation_player.animation_finished
    EventBus.player_dead.emit()

func find_closest_enemy() -> void:
    all_enemy = get_tree().get_nodes_in_group("Enemy")
    
    for enemy in all_enemy:
        if not closest_enemy:
            closest_enemy = enemy
        
        var enemy_distance = position.distance_to(enemy.position)
        if enemy_distance < closest_distance:
            closest_distance = enemy_distance
            closest_enemy = enemy
