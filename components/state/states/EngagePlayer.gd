extends State

class_name EngagePlayer

func process(_delta: float):
	var target = self.owner.player_units.get_average_position()
	if target:
		transitioned.emit("AttackMove", {"target": target})
	else:
		transitioned.emit("VictoryDance", {})
