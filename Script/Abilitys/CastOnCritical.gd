extends AbilityScene

func _ready() -> void:
    print("COC 就绪")
    EventBus.player_criticaled.connect(func():
        # TODO: 暴击时释放
        print("暴击")
        ability_data.active_sub_abilitys()
        )
