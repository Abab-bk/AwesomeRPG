extends Control

@onready var skills_ui:WorldmapView = %WorldmapView
@onready var root_item:WorldmapGraph = %RootItem

@onready var cancel_btn:Button = %CancelBtn
@onready var skill_tree_tooltip:Panel = %SkillTreeTooltip

@onready var talent_point_label:Label = %TalentPointLabel

var sub_node_offset:Vector2 = Vector2(0, 150)
var normal_node_offset:Vector2 = Vector2(0, 300)

var node_pos:Vector2 = Vector2(509, 953)

var last_parent_id:int = 0
var next_skill_id:int

var added_sub_nodes:Array[int] = []

func update_ui() -> void:
    talent_point_label.text = "天赋点：%s" % str(skills_ui.max_unlock_cost)

func get_skill_node_data(_id:int) -> WorldmapNodeData:
    var _data:WorldmapNodeData = WorldmapNodeData.new()
    var _ability_data = Master.ability_trees[_id]
    
    _data.id = str(_id)
    _data.texture = load(_ability_data["icon_path"])
    _data.name = _ability_data["name"]
    _data.desc = _ability_data["desc"]
    _data.cost = _ability_data["cost"]
    
    return _data

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
    
    return
    
    skills_ui.node_gui_input.connect(_on_node_gui_input)
    
    for i in Master.ability_trees.keys():
        if str(i) == str(0):
            last_parent_id = 0
            continue
        
        if i in added_sub_nodes:
            print("Skip：  ", i)
            continue
        
        print("Current：  ", i)
        
        node_pos += normal_node_offset
        
        add_a_skill_node(last_parent_id, str(i))
        last_parent_id = i
        
        var _offset:Vector2 = Vector2(0, 0)
        for child_id in Master.ability_trees[i]["child_skills"]:    
            var _pos:Vector2 = node_pos + Vector2(250, 0) + _offset
            add_a_sub_skill_node(i, str(i), _pos)
            added_sub_nodes.append(child_id)
            _offset += sub_node_offset
    
    var _temp_count:int = -1
    for i in root_item.node_datas.size():
        _temp_count += 1
        root_item.node_datas[_temp_count] = get_skill_node_data(_temp_count)
    
    skills_ui.recalculate_map()
    skills_ui.max_unlock_cost = 100
    
    print(root_item.get_child(1).name)
    #skills_ui.set_node_state(root_item.get_child(1).get_path(), 2, 1)
    skills_ui.recalculate_map()
        
    update_ui()

func _on_node_gui_input(_event:InputEvent, _path:NodePath, _node_in_path:int, _resource:WorldmapNodeData) -> void:
    if _event is InputEventMouseMotion:
        skill_tree_tooltip.global_position = _event.global_position + Vector2(50, 50)
        skill_tree_tooltip.show_skill(_resource)
    if _event is InputEventMouseButton:
        if _event.button_index == MOUSE_BUTTON_LEFT && _event.pressed:
            update_ui()
            if skills_ui.can_activate(_path, _node_in_path):
                #skill_tree_tooltip.show()
                print("可以解锁")
                skills_ui.max_unlock_cost -= skills_ui.set_node_state(_path, _node_in_path, 1)        
                update_ui()
            else:
                print("不能解锁，需要：", _resource.cost)
            update_ui()            


    
