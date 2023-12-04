extends AbilityScene

# FIX: COC不能正确卸载

func _ready() -> void:
    EventBus.player_criticaled.connect(func():
        ability_data.active_sub_abilitys()
        )
