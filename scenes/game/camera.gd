extends Camera2D

func _physics_process(delta):
	# FIXME limit speed to snap back slowly when unit dies
	position = %PlayerUnits.get_average_position()

	# FIXME bound borders to game field
