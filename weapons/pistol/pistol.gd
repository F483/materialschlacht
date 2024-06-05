extends Weapon

const BULLET = preload("res://entities/bullet/bullet.tscn")

func shoot():
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)
	fired.emit(new_bullet)
