extends TextureRect

signal selected

var data:FlowerAbility:
    set(v):
        if v:
            data = v
            texture = load(data.icon_path)

func _ready() -> void:
    $Button.pressed.connect(func():
        selected.emit(data)
        )
