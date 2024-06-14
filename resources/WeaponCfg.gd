extends Resource

class_name WeaponCfg

@export var color_primary: Color = Color(1,1,1,1)
@export var color_secondary: Color = Color(1,1,1,1)

@export var accuracy: float = 3.14 / 8
@export var cycle_time: float = 0.1

@export_flags_2d_physics var targeting_layer: int = 0
@export_flags_2d_physics var targeting_mask: int = 0

@export var bullet_speed: float = 666.666
@export var bullet_range: float = 666.666
@export var bullet_physics_cfg: PhysicsCfg = null

