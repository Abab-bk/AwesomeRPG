extends Panel

@onready var title_label:Label = %TitleLabel
@onready var desc_label:Label = %DescLabel

func show_skill(_data:WorldmapNodeData) -> void:
    title_label.text = _data.name
    desc_label.text = _data.desc
