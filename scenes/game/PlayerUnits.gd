extends Node2D

func get_average_position():
	var total_position = Vector2.ZERO
	var player_units = get_children()
	if player_units:
		for child in player_units:
			total_position = total_position + child.global_position
		return total_position / player_units.size()
	else:
		return Vector2.ZERO
