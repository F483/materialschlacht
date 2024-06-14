extends Area2D

class_name Weapon

signal fired(bullet: Array[Bullet])

@export var safty: bool = true

@onready var game = get_node("/root/Game")

var aiming: bool = false

signal weapon_cfg_updated(value: WeaponCfg)

@export var weapon_cfg: WeaponCfg = null:
    set (value):
        weapon_cfg = value
        weapon_cfg_updated.emit(weapon_cfg)

func _ready():
    self.weapon_cfg_updated.connect(set_physics_cfg)
    set_physics_cfg(self.weapon_cfg)

func set_physics_cfg(weapon_cfg: WeaponCfg):
    collision_layer = weapon_cfg.targeting_layer
    collision_mask = weapon_cfg.targeting_mask

func trigger():
    if aiming and not safty:
        var bullets = shoot()
        for bullet in bullets:
            bullet.entity_owner = self.owner
            bullet.weapon_cfg = self.weapon_cfg
            %ShootingPoint.add_child(bullet)
        fired.emit(bullets)
        
        # TODO add shoot signal and hook that instead with other fx ...
        var shootSfx = self.get_node("ShootSfx")
        if shootSfx:
            shootSfx.play()
        

func find_targetable_enemies() -> Array[Node2D]:
    return Utils.filter_obscured(
        self,
        get_overlapping_bodies(),
        Config.m_highground,
        Config.m_concealment
    )
    
func aim_at(target):
    if target:
        look_at(target.global_position)
        var r = int(global_rotation_degrees) % 365
        var gsy = get_parent().global_scale.y
        if r < -90 or r > 90:
            scale.y = abs(scale.y) * -1 * gsy
        else:
            scale.y = abs(scale.y) * gsy
        aiming = true
    else:
        rotation = 0
        scale.y = abs(scale.y)
        aiming = false

func shoot():
    assert(false, "Required method 'shoot' not implemented by weapon.")
