extends Control

@onready var skills_ui:WorldmapView = %WorldmapView
@onready var root_item:WorldmapGraph = %RootItem

@onready var cancel_btn:Button = %CancelBtn


func _ready() -> void:
    cancel_btn.pressed.connect(func():
        SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
        owner.change_page(owner.PAGE.HOME))

# {3001: {xx}, 3002...}

#var data:Dictionary = {
#    3001: {
#        "name": "怒吼",
#        "next_skill_id": 3002,
#        "child_skills": []
#    },
#    3002: {
#        "name": "怒吼2",
#        "next_skill_id": 0,
#        "child_skills": [3003, 3004]
#    },
#    3003: {
#        "name": "灼烧",
#        "next_skill_id": 0,
#        "child_skills": []
#    },
#    3004: {
#        "name": "猛冲",
#        "next_skill_id": 0,
#        "child_skills": []
#    }
#}
#
#var skill_node_size = Vector2(100, 40)  # 调整节点的大小
#var skill_node_spacing = 60  # 调整节点之间的间距
#var node_pos:Vector2 = Vector2(495, 1746)
#
#
#func _ready() -> void:
#    for i in data:
#        if i == 3001:
##            add_node(node_pos, new_node_data(i))
##            node_pos += Vector2(200, 0)
#            continue
#
#        root_item.add_node(node_pos, new_node_data(i))
#
#func add_node(pos:Vector2, node:WorldmapNodeData) -> void:
#    root_item.node_datas.append(node)
#    root_item.node_positions.append(pos)
#
#func new_node_data(_id:int) -> WorldmapNodeData:
#    var _new_data:WorldmapNodeData = WorldmapNodeData.new()
#
#    _new_data.id = str(_id)
#    _new_data.texture = load("res://icon.svg")
#    _new_data.name = data[_id]["name"]
#
#    return _new_data
