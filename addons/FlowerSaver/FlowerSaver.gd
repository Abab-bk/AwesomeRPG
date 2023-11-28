extends Node

signal save_ok

const save_path:String = "user://awesomerpg.tres"
const save_path2:String = "user://awesomerpg2.tres"
const save_path3:String = "user://awesomerpg3.tres"

var save_data:SaveResource = SaveResource.new()
var loaded_data:SaveResource = SaveResource.new()

var base_resource_property_names:Array = []


func _ready() -> void:
    var res:Resource = Resource.new()
    for property in res.get_property_list():
        base_resource_property_names.append(property.name)
    save_ok.connect(func():print("保存完成"))


func del_save(path:String) -> void:
    var dir = DirAccess.open("user://")
    
    if dir.file_exists(path):
        dir.remove(path)


func save(path:String) -> void:
    if ResourceSaver.save(save_data, path) == OK:
        #if loaded_data.data.has("skill_tree_scene"):
            #save_data.data["skill_tree_scene"] = loaded_data.data["skill_tree_scene"]
        save_ok.emit()



func set_data(key:String, value) -> void:
    save_data.data[key] = value


func _resource_to_dict(resource:Resource) -> Dictionary:
    var dict:Dictionary = {}
    dict["class_name"] = resource.get_class()
    
    for property in resource.get_property_list():
        if base_resource_property_names.has(property.name) || property.name.ends_with(".gd"): 
            continue
        dict[property.name] = resource.get(property.name)
    
    return dict


func has_key(key:String) -> bool:
    if loaded_data.data.has(key):
        return true
    return false


func get_data_but_load(key:String, path:String) -> Variant:
    var _file
    
    if ResourceLoader.exists(path):
        _file = ResourceLoader.load(path)
    else:
        print("文件不存在")
        return false
    
    if _file == null:
        print("文件为null")
        return false
    
    var _data:Dictionary = _file.data as Dictionary
    
    if not _data.has(key):
        print("文件没有key")        
        return false
    
    var _result = _data[key]
    
    return _result


func get_data(key:String, path:String = "") -> Variant:
    if not loaded_data.data.has(key):
        return false
    
    return loaded_data.data[key]


func load_save(path:String) -> void:
    loaded_data = ResourceLoader.load(path)


func get_all_data() -> SaveResource:
    return save_data


func get_class_name_by_dic(_data:Dictionary) -> String:
    return _data["class_name"]
