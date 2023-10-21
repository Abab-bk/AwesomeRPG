extends TextureRect

signal selected

var data:FlowerAbility

func _ready() -> void:
    $Button.pressed.connect(func():
        selected.emit(data)
        )
