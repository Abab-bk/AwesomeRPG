extends Control

@onready var skills_ui:WorldmapView = %WorldmapView
@onready var root_item:WorldmapGraph = %RootItem

@onready var cancel_btn:Button = %CancelBtn

var skill_node_size = Vector2(100, 40)  # 调整节点的大小
var skill_node_spacing = 60  # 调整节点之间的间距
var node_pos:Vector2 = Vector2(496, 1953)

var last_parent_id:int
var next_skill_id:int

var added_sub_nodes:Array[int] = []

func get_skill_node_data(_id:int) -> WorldmapNodeData:
    var _result:WorldmapNodeData = WorldmapNodeData.new()
    
    return _result

func add_a_skill_node(_parent_id:int, _id:String) -> void:
    root_item.add_node(node_pos, _parent_id)
    skills_ui.recalculate_map()

func add_a_sub_skill_node(_parent_id:int, _id:String, _node_pos:Vector2) -> void:
    root_item.add_node(_node_pos, _parent_id)    
    skills_ui.recalculate_map()

func _ready() -> void:
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        owner.change_page(owner.PAGE.HOME))
    
    for i in Master.ability_trees.keys():
        if str(i) == str(3001):
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
