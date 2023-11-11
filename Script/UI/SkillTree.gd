extends Control

@onready var skills_ui:WorldmapView = %WorldmapView
@onready var root_item:WorldmapGraph = %RootItem

@onready var cancel_btn:Button = %CancelBtn
@onready var skill_tree_tooltip:Panel = %SkillTreeTooltip

var skill_node_size = Vector2(100, 40)  # 调整节点的大小
var skill_node_spacing = 60  # 调整节点之间的间距
var node_pos:Vector2 = Vector2(496, 1953)

var last_parent_id:int
var next_skill_id:int

var added_sub_nodes:Array[int] = []

func get_skill_node_data(_id:int) -> WorldmapNodeData:
    var _data:WorldmapNodeData = WorldmapNodeData.new()
    var _ability_data = Master.ability_trees[_id]
    
    _data.id = str(_id)
    _data.texture = load(_ability_data["icon_path"])
    _data.name = _ability_data["name"]
    _data.desc = _ability_data["desc"]
    _data.cost = _ability_data["cost"]
    
    return _data

func set_node_data(_node_data:WorldmapNodeData, _id:int) -> void:
    #_node_data = _node_data.duplicate(true)
    _node_data = get_skill_node_data(_id).duplicate(true)
    #_node_data.id = _temp_data.id
    #_node_data.texture = _temp_data.texture
    #_node_data.name = _temp_data.name
    #_node_data.desc = _temp_data.desc
    #_node_data.cost = _temp_data.cost

func add_a_skill_node(_parent_id:int, _id:String) -> void:
    root_item.add_node(node_pos, _parent_id)
    skills_ui.recalculate_map()

func add_a_sub_skill_node(_parent_id:int, _id:String, _node_pos:Vector2) -> void:
    root_item.add_node(_node_pos, _parent_id)    
    skills_ui.recalculate_map()

func _on_node_gui_input(_event:InputEvent, _path:NodePath, _node_in_path:int, _resource:WorldmapNodeData) -> void:
    if _event is InputEventMouseMotion:
        skill_tree_tooltip.global_position = _event.global_position + Vector2(50, 50)
        skill_tree_tooltip.show_skill(_resource)

func _ready() -> void:
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        owner.change_page(owner.PAGE.HOME))
    
    skills_ui.node_gui_input.connect(_on_node_gui_input)
    
    for i in Master.ability_trees.keys():
        if str(i) == str(0):
            last_parent_id = 0
            continue
        
        if i in added_sub_nodes:
            print("跳过：  ", i)
            continue
        
        print("当前：  ", i)
        
        node_pos += Vector2(0, 180)
        
        add_a_skill_node(last_parent_id, str(i))
        last_parent_id = i
        
        for child_id in Master.ability_trees[i]["child_skills"]:
            var _offset:Vector2 = Vector2(0, 250)
            var _pos:Vector2 = node_pos + Vector2(250, 0) + _offset
            add_a_sub_skill_node(i, str(i), _pos)
            added_sub_nodes.append(child_id)
    
    var _temp_count:int = -1
    for i in root_item.node_datas:
        _temp_count += 1
        root_item.node_datas[_temp_count] = get_skill_node_data(_temp_count)

    skills_ui.recalculate_map()
