extends Weapon

@export_range(2, 16) var shot_count: int = 8

# TODO add boolean for random vs even spread
# TODO deg not radian and correct editor widget
@export var shot_spread: float = 3.14 / 8

const BULLET = preload("res://projectiles/bullet/bullet.tscn")

func shoot():
	var bullets = []
	for n in shot_count:
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + (
			n * (shot_spread / (shot_count - 1)) - (shot_spread / 2.0)
		)
		bullets.append(new_bullet)
	return bullets

