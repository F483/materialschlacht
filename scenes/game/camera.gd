extends Camera2D

func _physics_process(delta):
	position = %PlayerUnits.get_average_position()
	# FIXME limit speed to snap back slowly when unit dies
