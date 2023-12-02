extends Node2D

@export var save:bool = false
@export var load_save:bool = false

@onready var enemy_home:EnemyHome = %EnemyHome


func _ready() -> void:
    Master.world = self
    
    EventBus.rework_level_enemy_count.connect(rework_level_enemy_count)
    EventBus.completed_level.connect(completed_level)
    EventBus.flyed.connect(func():
        completed_level()
        EventBus.completed_level.emit()
        EventBus.update_ui.emit()
        )
    
    EventBus.enter_dungeon.connect(func(_data:DungeonData):
        Master.in_dungeon = true
        enemy_home.kill_all_enemy()
        enemy_home.spawn_a_special_enemy(func():
            # 地牢奖励
            get_data_reward(_data)
            Master.in_dungeon = false, _data.enemy_id))
    
    # data {ui_id: id}
    EventBus.changed_friends.connect(func(_data:Dictionary):
        EventBus.kill_all_friend.emit()
        
        Tracer.info("玩家随从改变，应该杀死所有玩家")
        
        var _count:int = -1
        for i in _data.keys():
            if _data[i] == -1:
                continue
            
            _count += 1
            
            spawn_a_friend_by_id(_data[i], Master.player.friends_pos[_count])
        )
    
    #EventBus.start_climb_tower.connect(func():)
    
    if Master.current_level == 0:
        EventBus.completed_level.emit()
    EventBus.update_ui.emit()
    #EventBus.load_save.connect(completed_level)
    
    SoundManager.play_music(load(Master.BGM), 0, "Music")
    
    if Master.should_load:
        FlowerSaver.load_save(Master.current_save_slot)
        print("加载存档 - 世界")
        EventBus.load_save.emit()
        Master.should_load = false

func spawn_a_friend_by_id(_id:int, _point:Marker2D) -> void:
    var _friend_data = Master.friends[_id]
    
    var new_friend:Friend = Builder.build_a_friend() as Friend
    
    new_friend.skin_name = _friend_data["skin_name"]
    new_friend.target_player_point = _point
    
    var _data:CharacterData = CharacterData.new()
    _data.damage = _friend_data["base_damage"]
    _data.frost_damage = _friend_data["frost_damage"]
    _data.fire_damage = _friend_data["fire_damage"]
    _data.light_damage = _friend_data["light_damage"]
    _data.toxic_damage = _friend_data["toxic_damage"]
    _data.frost_resistance = _friend_data["frost_resistance"]
    _data.fire_resistance = _friend_data["fire_resistance"]
    _data.light_resistance = _friend_data["light_resistance"]
    _data.toxic_resistance = _friend_data["toxic_resistance"]
    _data.max_hp = _friend_data["hp"]
    _data.hp = _friend_data["hp"]
    _data.speed = _friend_data["speed"]
    
    new_friend.set_data(_data)
    call_deferred("add_child", new_friend)
    new_friend.global_position = Master.player.global_position + Vector2(200, 200)


func rework_level_enemy_count() -> void:
    completed_level()

func completed_level() -> void:
    enemy_home.min_enemy_count = Master.current_level * 1
    enemy_home.max_enemy_count = Master.current_level * 5


func get_data_reward(_data:DungeonData) -> void:
    match _data.reward_type:
        "Coins":
            Master.coins += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s 金币" % str(_data.reward_value))
        "MoneyWhite":
            Master.moneys.white += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.white])
        "MoneyBlue":
            Master.moneys.blue += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.blue])
        "MoneyPurple":
            Master.moneys.purple += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.purple])
        "MoneyYellow":
            Master.moneys.yellow += _data.reward_value
            EventBus.show_popup.emit("挑战成功！", "获得奖励：%s %s" % [str(_data.reward_value), Const.MONEYS_NAME.yellow])
        "Function":
            match _data.reward_value:
                1:
                    # 解锁飞升
                    EventBus.unlock_new_function.emit("fly")
                    EventBus.show_popup.emit("挑战成功！", "解锁飞升！")
        "GoldEquipment":
            var _generator:ItemGenerator = ItemGenerator.new()
            add_child(_generator)
            
            for i in _data.reward_value:
                _generator.gen_a_item(true, true)
            EventBus.show_popup.emit("挑战成功！", "获得传奇装备！")
            _generator.queue_free()
