extends Node

signal save_ok

const save_path:String = "user://awesomerpg.tres"
const save_path2:String = "user://awesomerpg2.tres"
const save_path3:String = "user://awesomerpg3.tres"

var save_data:SaveResource = SaveResource.new()
var loaded_data:SaveResource = SaveResource.new()


func _ready() -> void:    
    #save_ok.connect(func():
        #Tracer.info("存档成功")
        #)
    pass

func del_save(path:String) -> void:
    var dir = DirAccess.open("user://")
    
    if dir.file_exists(path):
        dir.remove(path)


func save(path:String) -> void:
    if ResourceSaver.save(save_data, path) == OK:
        save_ok.emit()


func set_data(key:String, value) -> void:
    save_data.data[key] = value


func has_key(key:String) -> bool:
    if loaded_data.data.has(key):
        return true
    return false


func get_data_but_load(key:String, path:String) -> Variant:
    var _file
    
    if ResourceLoader.exists(path):
        _file = ResourceLoader.load(path)
    else:
        return false
    
    if _file == null:
        return false
    
    var _data:Dictionary = _file.data as Dictionary
    
    if not _data.has(key):     
        return false
    
    var _result = _data[key]
    
    return _result


func get_data(key:String, path:String = "") -> Variant:
    if not loaded_data.data.has(key):
        return false
    
    return loaded_data.data[key]


func load_save(path:String) -> void:
    loaded_data = ResourceLoader.load(path)
    save_data = loaded_data.duplicate(true)


func get_all_data() -> SaveResource:
    return save_data
