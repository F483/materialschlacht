extends Entity
	
func _physics_process(_delta):
	# TODO target last unit that attacked pipi!
	var movement = self.get_node("Movement")
	movement.target =  player_units.get_average_position()
