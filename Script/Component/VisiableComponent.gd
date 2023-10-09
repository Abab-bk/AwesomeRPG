class_name VisiableComponent extends Area2D

func target_is_in_range(target:Node) -> bool:
    if overlaps_body(target):
        return true
    return false
