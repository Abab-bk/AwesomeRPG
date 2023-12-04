extends AbilityScene

var _temp_buff_list:Array[FlowerBaseBuff]

func _ready() -> void:
    _temp_buff_list.append(Builder.get_a_simple_buff("toxic_resistance", (actor.output_data.toxic_resistance * 0.06), FlowerConst.COMPUTE_TYPE.MORE))
    _temp_buff_list.append(Builder.get_a_simple_buff("physical_resistance", (actor.output_data.physical_resistance * 0.06), FlowerConst.COMPUTE_TYPE.MORE))
    actor.flower_buff_manager.add_buff_list(_temp_buff_list)

func timeout() -> void:
    # 会自动queue_free()
    actor.flower_buff_manager.remove_buff_list(_temp_buff_list)
    super()

