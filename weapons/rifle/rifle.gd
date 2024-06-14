extends Weapon

const BULLET = preload("res://projectiles/bullet/bullet.tscn")

var rng = RandomNumberGenerator.new() # TODO correct for deterministic replay rng?

func _ready():
    super()
    %Timer.wait_time = self.weapon_cfg.cycle_time
    
func shoot():
    var new_bullet = BULLET.instantiate()
    new_bullet.global_position = %ShootingPoint.global_position
    new_bullet.global_rotation = %ShootingPoint.global_rotation + (
        rng.randf_range(
            -(self.weapon_cfg.accuracy / 2.0), 
            self.weapon_cfg.accuracy / 2.0
        )
    )
    return [new_bullet]
    
