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
        if progress_bar.value <= 0.0:
            EventBus.player_ability_activate.emit(ability)
        )

func set_ability(_v:FlowerAbility) -> void:
    ability = _v
    print("set ability: ", ability.name)

func _physics_process(_delta:float) -> void:
    if ability:
        progress_bar.value = ability.get_cooldown_left()    

func update_ui() -> void:
    title_label.text = ability.name
    icon.texture = ability.icon
    progress_bar.texture_progress = ability.icon
    progress_bar.value = ability.get_cooldown_left()
    progress_bar.max_value = ability.cooldown
