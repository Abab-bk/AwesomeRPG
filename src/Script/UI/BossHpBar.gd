extends MarginContainer

@onready var title_label:Label = %TitleLabel
@onready var boss_hp_bar:ProgressBar = %BossHpBar

var should_fresh:bool = false

var enemy_data:CharacterData

func _ready() -> void:
    EventBus.boss_appear.connect(func(_boss_data:CharacterData):
        enemy_data = _boss_data
        title_label.text = _boss_data.name
        set_physics_process(true)
        show()
        )
    EventBus.boss_dead.connect(func():
        set_physics_process(false)
        hide()
        )
    
    hide()
    set_physics_process(false)

func _physics_process(_delta:float) -> void:
    boss_hp_bar.value = (enemy_data.hp / enemy_data.max_hp) * 100.0
