extends Node2D

class_name DirectionFlipper

func _physics_process(_delta):
    var parent = get_parent()
    var vx = parent.velocity.x
    if vx > 0:
        scale.x = abs(scale.x)
    elif vx < 0:
        scale.x = abs(scale.x) * -1
