class_name SkillBtn extends Panel

@onready var icon:TextureRect = %Icon
@onready var progress_bar:TextureProgressBar = %ProgressBar
@onready var title_label:Label = %TitleLabel
@onready var button:Button = %Button

var ability:Ability:
    set(v):
        ability = v
        update_ui()

func _ready() -> void:
    button.pressed.connect(func():
        EventBus.player_ability_activate.emit(ability)
        )

func set_ability(_v:Ability) -> void:
    ability = _v

func update_ui() -> void:
    title_label.text = ability.ui_name
    icon.texture = ability.ui_icon
    progress_bar.value = ability.cooldown_duration
