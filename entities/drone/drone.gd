extends Entity

func _physics_process(_delta):
    var movement = self.get_node("Movement")
    var children = Utils.get_2dchildren(player_units)
    if children.size() > 0:
        var closest = Utils.find_closest(self, children)
        movement.target =  closest.global_position
    else:
        movement.target = Vector2.ZERO
