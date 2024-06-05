extends Weapon

@export var accuracy: float = 3.14 / 8
@export var cycle_time: float = 0.1

const BULLET = preload("res://projectiles/bullet/bullet.tscn")

var rng = RandomNumberGenerator.new() # TODO global deterministic rng

func _ready():
	super()
	%Timer.wait_time = cycle_time
	
func shoot():
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation + (
		rng.randf_range(-(accuracy / 2.0) , accuracy / 2.0)
	)
	return [new_bullet]
	
