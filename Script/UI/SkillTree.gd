extends Control

@export var step_count:int = 100

@onready var skills_ui:WorldmapView
@onready var root_item:WorldmapGraph

@onready var cancel_btn:Button = %CancelBtn
@onready var skill_tree_tooltip:Panel = %SkillTreeTooltip

@onready var talent_point_label:Label = %TalentPointLabel

var node_pos:Vector2 = Vector2(509, 953)
var last_parent_id:int = 0

var added_sub_nodes:Array[int] = []
var added_node_pos:Array[Vector2] = []


func update_ui() -> void:
    talent_point_label.text = "天赋点：%s" % str(skills_ui.max_unlock_cost)


func get_skill_node_data(_id:int) -> WorldmapNodeData:
    var _data:WorldmapNodeData = WorldmapNodeData.new()
    var _ability_data = Master.talent_buffs[Master.talent_buffs.keys().pick_random()]
    
    var _offset:float = randf_range(0.1, 1.0)
    
    _data.id = str(_id)
    _data.texture = load(_ability_data["icon_path"])
    _data.name = _ability_data["name"].format({"s": str(_offset * 10).pad_decimals(1)})
    _data.cost = _ability_data["cost"]
    
    return _data


func add_a_skill_node(_parent_id:int, _id:int) -> void:
    root_item.add_node(node_pos, _parent_id, get_skill_node_data(_id))
    skills_ui.recalculate_map()


func add_a_sub_skill_node(_parent_id:int, _id:int, _node_pos:Vector2) -> void:
    root_item.add_node(_node_pos, _parent_id, get_skill_node_data(_id))
    skills_ui.recalculate_map()


func _ready() -> void:
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        owner.change_page(owner.PAGE.HOME))
    $Panel/Button.pressed.connect(gen_trees_by_walker.bind(step_count))
    
    skills_ui = %TalentTree.worldmap_view
    root_item = %TalentTree.root_item
    
    skills_ui.node_gui_input.connect(_on_node_gui_input)
    skills_ui.max_unlock_cost = 100
    skills_ui.recalculate_map()
    
    added_node_pos.append(node_pos)
    
    update_ui()


func gen_trees_by_walker(_step:int) -> void:
    var _step_size:Vector2 = Vector2(300, 0)
    
    for i in _step:
        # 判断是否要转向
        var _dir:int = [0, 1, 2, 3].pick_random()
        match _dir:
            # 向左转
            0:
                _step_size = Vector2(300, 0)
            # 向右转
            1:
                _step_size = Vector2(-300, 0)
            # 向上转
            2:
                _step_size = Vector2(0, 300)
            # 向下转
            3:
                _step_size = Vector2(0, -300)
        
        while node_pos in added_node_pos:
            node_pos += _step_size
        
        # 添加节点
        var _id:int = last_parent_id + 1
        add_a_skill_node(last_parent_id, _id)
        added_node_pos.append(node_pos)
        last_parent_id = _id


func _on_node_gui_input(_event:InputEvent, _path:NodePath, _node_in_path:int, _resource:WorldmapNodeData) -> void:
    if _event is InputEventMouseMotion:
        skill_tree_tooltip.global_position = _event.global_position + Vector2(150, 150)
        skill_tree_tooltip.show_skill(_resource)
    if _event is InputEventMouseButton:
        if _event.button_index == MOUSE_BUTTON_LEFT && _event.pressed:
            update_ui()
            if skills_ui.can_activate(_path, _node_in_path):
                print("可以解锁")
                skills_ui.max_unlock_cost -= skills_ui.set_node_state(_path, _node_in_path, 1)        
                update_ui()
            else:
                print("不能解锁，需要：", _resource.cost)
            update_ui()

