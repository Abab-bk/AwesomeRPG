extends HBoxContainer

signal changed

@export var target_component:Sprite2D
@export var display_text:String

@onready var previous_btn:Button = %PreviousBtn
@onready var label:Label = %Label
@onready var next_btn:Button = %NextBtn

var origin_signals:String = ""
@export var signals:String = "":
    set(v):
        if origin_signals == "":
            origin_signals = signals
        signals = "res://Assets/Characters/PlayerAssets/" + v
        set_datas()

var datas:Array = []

var current_index:int = 0:
    set(v):
        current_index = max(0, v)
        changed.emit()

func _ready() -> void:
    previous_btn.pressed.connect(func():
        current_index -= 1
        
        if datas.size() > current_index:
            label.text = display_text + str(current_index + 1)
        else:
            current_index = 0
            label.text = display_text + str(current_index + 1)
        
        target_component.texture = load(datas[current_index][1])
        target_component.centered = false
        )
    next_btn.pressed.connect(func():
        current_index += 1
        
        if datas.size() > current_index:
            label.text = display_text + str(current_index + 1)
        else:
            current_index = 0
            label.text = display_text + str(current_index + 1)
            
        target_component.texture = load(datas[current_index][1])
        target_component.centered = false
        )
    
    next_btn.pressed.emit()    
    previous_btn.pressed.emit()

func set_datas() -> void:
    var dir:DirAccess = DirAccess.open(signals)
    if not dir:
        return
    
    datas = []
    
    for file_name in dir.get_files():
        if ".import" in file_name:
            var x = file_name.replace(".import", "")
            datas.append([origin_signals, signals + "/" + x])
            print(x)
        
