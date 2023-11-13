extends Panel

@onready var title_label:Label = %TitleLabel
@onready var cost_label:Label = %CostLabel

func show_skill(_data:WorldmapNodeData) -> void:
    title_label.text = _data.name
    cost_label.text = "消耗 %s 天赋点" % str(_data.cost)
