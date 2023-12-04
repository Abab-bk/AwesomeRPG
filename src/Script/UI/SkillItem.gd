extends Panel

@onready var icon:TextureRect = %Icon
@onready var progress_bar:TextureProgressBar = %ProgressBar
@onready var title_label:Label = %TitleLabel
@onready var button:Button = %Button

var ability:FlowerAbility:
    set(v):
        ability = v
        update_ui()

func _ready() -> void:
    button.pressed.connect(func():
        if not progress_bar.value <= 0.0:
            return
        
        match ability.cost_type:
            0:
                if not Master.player_output_data.hp >= ability.cost_value:
                    EventBus.new_tips.emit("血量不足，无法释放")
                    return
            1:
                if not Master.player_output_data.magic >= ability.cost_value:
                    EventBus.new_tips.emit("魔力不足，无法释放")
                    return
        
        EventBus.player_ability_activate.emit(ability)
        )

func set_ability(_v:FlowerAbility) -> void:
    ability = _v

func _physics_process(_delta:float) -> void:
    if ability:
        progress_bar.value = ability.get_cooldown_left() 

func update_ui() -> void:
    title_label.text = ability.name
    icon.texture = load(ability.icon_path)
    progress_bar.texture_progress = load(ability.icon_path)
    progress_bar.value = ability.get_cooldown_left()
    progress_bar.max_value = ability.cooldown
