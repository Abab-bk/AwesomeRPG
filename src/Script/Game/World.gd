extends Node2D

@export var save:bool = false
@export var load_save:bool = false

@onready var enemy_home:EnemyHome = %EnemyHome
@onready var wheathers:Node2D = $Wheathers


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
        enemy_home.kill_all_enemy()
        
        if _data.wheather_id != 0:
            change_wheather(Master.get_wheather_by_id(_data.wheather_id))
        
        enemy_home.spawn_a_special_enemy(func():
            # 地牢奖励
            _data.get_reward()
            EventBus.enter_dungeon_and_success.emit()
            EventBus.exit_dungeon.emit(), _data.enemy_id))
    
    EventBus.exit_dungeon.connect(recovery_wheather)
    EventBus.exit_tower.connect(recovery_wheather)
    
    # data {ui_id: id}
    EventBus.changed_friends.connect(func(_data:Dictionary):
        EventBus.kill_all_friend.emit()
        
        Tracer.info("玩家随从改变，应该杀死所有玩家")
        var _count:int = -1
        for i in _data.keys():
            if _data[i] == null:
                continue
            
            _count += 1
            
            spawn_a_friend_by_data(Master.friends_inventory[_data[i]], Master.player.friends_pos[_count])
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


func recovery_wheather() -> void:
    for _node:WheatherScene in wheathers.get_children():
        _node.disappear()
    Tracer.info("天气恢复晴天")
    
    Master.player.current_state = Player.STATE.IDLE


func change_wheather(_wheather:WheatherData) -> void:
    Tracer.info("天气改变：%s" % _wheather.name)
    wheathers.add_child(load(_wheather.scene_path).instantiate())


func spawn_a_friend_by_data(_data:FriendData, _point:Marker2D) -> void:
    var new_friend:Friend = Builder.build_a_friend() as Friend
    
    new_friend.skin_name = _data["skin_name"]
    new_friend.target_player_point = _point
    
    new_friend.set_data(_data.character_data)
    call_deferred("add_child", new_friend)
    new_friend.global_position = Master.player.global_position + Vector2(200, 200)


func rework_level_enemy_count() -> void:
    completed_level()


func completed_level() -> void:
    enemy_home.min_enemy_count = Master.current_level * 1
    enemy_home.max_enemy_count = Master.current_level * 5

