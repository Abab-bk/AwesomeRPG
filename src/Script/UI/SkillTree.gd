extends Control

const DISTANCE:int = 300

@export var step_count:int = 100

@onready var skills_ui:WorldmapView
@onready var root_item:WorldmapGraph

@onready var unlock_btn:Button = %UnlockBtn

@onready var talent_point_label:Label = %TalentPointLabel
@onready var talent_title:Label = %TalentTitle
@onready var talent_desc:RichTextLabel = %TalentDesc

@onready var talent_tree:Node = %TalentTree

@onready var title_bar:MarginContainer = $Panel/MarginContainer/VBoxContainer/TitleBar

var node_pos:Vector2 = Vector2(509, 953)
var last_parent_id:int = 0

var added_sub_nodes:Array[int] = []
var added_node_pos:Array[Vector2] = []

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)

var current_item:WorldmapNodeData
var closest_path:NodePath
var closest_node_in_path:int


var saved_datas:Dictionary
var saved_inner_data
var loaded:bool = false


func update_ui(_data:WorldmapNodeData = null) -> void:
    talent_point_label.text = "天赋点：%s" % str(skills_ui.max_unlock_cost)
    if _data:
        talent_desc.text = "[center]%s
消耗：%s 天赋点
[/center]" % [_data.name, str(_data.cost)]


func get_skill_node_data(_id:int) -> WorldmapNodeData:
    var _data:WorldmapNodeData = WorldmapNodeData.new()
    var _data_id:int = Master.talent_buffs.keys().pick_random()
    var _ability_data = Master.talent_buffs[_data_id]
    
    var _offset:float = randf_range(1.0, 2.0)
    
    _data.id = str(_id)
    _data.texture = load("res://Assets/UI/Icons/TalentIcons/" + _ability_data["icon_path"])
    _data.name = _ability_data["name"].format({"s": str(_offset).pad_decimals(1)})
    _data.cost = _ability_data["cost"]
    
    _data.data.append(Master.get_talent_buff_by_id(_data_id, _offset))
    
    return _data


func add_a_skill_node(_parent_id:int, _id:int) -> void:
    var _data = get_skill_node_data(_id)
    root_item.add_node(node_pos, _parent_id, _data)
    
    if not saved_datas.has(_parent_id):
        saved_datas[_parent_id] = {}
    
    saved_datas[_parent_id]["data"] = _data
    
    skills_ui.recalculate_map()


func add_a_skill_node_and_pos_data(_parent_id:int, _id:int, _pos:Vector2, _data) -> void:
    root_item.add_node(_pos, _parent_id, _data)
    skills_ui.recalculate_map()


func add_a_sub_skill_node(_parent_id:int, _id:int, _node_pos:Vector2) -> void:
    root_item.add_node(_node_pos, _parent_id, get_skill_node_data(_id))
    skills_ui.recalculate_map()


func _ready() -> void:
    unlock_btn.pressed.connect(func():
        if not closest_node_in_path:
            return
        if not closest_path:
            return
        if skills_ui.can_activate(closest_path, closest_node_in_path):
            unlock_btn.disabled = false
            skills_ui.max_unlock_cost -= skills_ui.set_node_state(closest_path, closest_node_in_path, 1)
            
            var _buff:FlowerBaseBuff = current_item.data[0]
            Master.player_data[_buff.compute_values[0]["target_property"]] += _buff.compute_values[0]["value"]
            
            update_ui(current_item)
            save()
        )
    
    title_bar.cancel_callable = cancel_event
    
    skills_ui = %TalentTree.worldmap_view
    root_item = %TalentTree.root_item
    
    skills_ui.node_gui_input.connect(_on_node_gui_input)
    skills_ui.max_unlock_cost = 0
    skills_ui.recalculate_map()
    
    added_node_pos.append(node_pos)
    
    EventBus.load_save.connect(func():
        if FlowerSaver.has_key("skill_tree_data"):
            saved_datas = FlowerSaver.get_data("skill_tree_data")
            loaded = true
        )
    EventBus.get_talent_point.connect(func(_count:int):
        skills_ui.max_unlock_cost += _count
        )
    
    update_ui()

    await get_tree().create_timer(1.0).timeout
    gen_trees_by_walker()


func save() -> void:
    Tracer.info("保存技能树")
    saved_inner_data = {
        "state": skills_ui.get_state(),
        "cost": skills_ui.max_unlock_cost
    }
    FlowerSaver.set_data("skill_tree_data", saved_datas)
    FlowerSaver.set_data("saved_inner_data", saved_inner_data)


func load_save() -> void:
    await get_tree().create_timer(2.0).timeout
    skills_ui.recalculate_map()
    saved_datas = FlowerSaver.get_data("skill_tree_data")
    saved_inner_data = FlowerSaver.get_data("saved_inner_data")
    skills_ui.load_state(saved_inner_data["state"])
    skills_ui.max_unlock_cost = saved_inner_data["cost"]
    skills_ui.recalculate_map()
    update_ui()
    

func gen_trees_by_walker() -> void:
    if loaded:
        for _key in saved_datas.keys():
            var _data = saved_datas[_key]
            add_a_skill_node_and_pos_data(_data["last_parent_id"], _data["id"], _data["node_pos"], _data["data"])
        
        load_save()
        return
    
    var _step_size:Vector2 = Vector2(DISTANCE, 0)
    
    for i in step_count:
        # 判断是否要转向
        var _dir:int = [0, 1, 2].pick_random()
        match _dir:
            # 向左转
            0:
                _step_size = Vector2(DISTANCE, 0)
            # 向右转
            1:
                _step_size = Vector2(-DISTANCE, 0)
            # 向上转
            2:
                _step_size = Vector2(0, DISTANCE)
            # 向下转
            3:
                _step_size = Vector2(0, -DISTANCE)
        
        while node_pos in added_node_pos:
            node_pos += _step_size
        
        # 添加节点
        var _id:int = last_parent_id + 1
        
        saved_datas[last_parent_id] = {
            "last_parent_id": last_parent_id,
            "id": _id,
            "node_pos": node_pos,
        }
        add_a_skill_node(last_parent_id, _id)
                
        added_node_pos.append(node_pos)
        last_parent_id = _id
    save()


func _on_node_gui_input(_event:InputEvent, _path:NodePath, _node_in_path:int, _resource:WorldmapNodeData) -> void:
    if _event is InputEventMouseButton:
        if _event.button_index == MOUSE_BUTTON_LEFT && _event.pressed:
            closest_node_in_path = _node_in_path
            closest_path = _path
            current_item = _resource
            update_ui(_resource)
