extends HBoxContainer

signal changed

@export var target_component:Sprite2D

@onready var previous_btn:Button = %PreviousBtn
@onready var label:Label = %Label
@onready var next_btn:Button = %NextBtn

var origin_signals:String = ""
var signals:String = "":
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
            label.text = datas[current_index][0]
        else:
            current_index = 0
            label.text = datas[current_index][0]
        
        target_component.texture = load(datas[current_index][1])
        )
    next_btn.pressed.connect(func():
        current_index += 1
        
        if datas.size() > current_index:
            label.text = datas[current_index][0]
        else:
            current_index = 0
            label.text = datas[current_index][0]
            
        target_component.texture = load(datas[current_index][1])
        )

func set_datas() -> void:
    var dir:DirAccess = DirAccess.open(signals)
    if not dir:
        return
    
    datas = []
    
    for file_name in dir.get_files():
        if ".import" in file_name:
            continue
        datas.append([origin_signals, signals + "/" + file_name])
    
    next_btn.pressed.emit()
    previous_btn.pressed.emit()
