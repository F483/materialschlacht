extends Area2D

class_name Bullet

@onready var game = get_node("/root/Game")

var entity_owner: Entity = null
var travelled_distance: float = 0
var velocity: Vector2 = Vector2.ZERO

signal weapon_cfg_updated(value: WeaponCfg)
signal physics_cfg_updated(value: PhysicsCfg)

@export var physics_cfg: PhysicsCfg = null:
    set (value):
        physics_cfg = value
        set_physics_cfg_data(value)
        physics_cfg_updated.emit(physics_cfg)

@export var weapon_cfg: WeaponCfg = null:
    set (value):
        weapon_cfg = value
        set_weapon_cfg_data(value)
        weapon_cfg_updated.emit(weapon_cfg)

func _ready():
    assert(self.entity_owner, "Entity owner not set!")
    assert(self.weapon_cfg, "Weapon config not set!")
    assert(self.physics_cfg, "Physics config not set!")
    self.weapon_cfg_updated.connect(set_weapon_cfg_data)
    self.physics_cfg_updated.connect(set_physics_cfg_data)
    self.set_weapon_cfg_data(self.weapon_cfg)
    self.set_physics_cfg_data(self.physics_cfg)

func set_physics_cfg_data(value: PhysicsCfg):
    self.collision_layer = value.object_layer
    self.collision_mask = value.object_mask

func set_weapon_cfg_data(value: WeaponCfg):
    self.physics_cfg = value.bullet_physics_cfg
    
    if Config.m_highground and (rotation < 0 or rotation > 180):
        collision_mask |= Utils.MASK_MAP_LEDGES
    else:
        collision_mask &= ~Utils.MASK_MAP_LEDGES
        
    var model = get_node("Polygon2D")
    model.color = weapon_cfg.color_primary

func _physics_process(delta):
    var direction = Vector2.RIGHT.rotated(rotation)
    velocity = direction * self.weapon_cfg.bullet_speed
    position += velocity * delta
    travelled_distance += self.weapon_cfg.bullet_speed * delta
    if travelled_distance > self.weapon_cfg.bullet_range:
        queue_free()

func _on_body_entered(body):
    queue_free()
    var death_fx = get_node("DeathFX")
    if death_fx:
        death_fx.trigger()  # FIXME if entity dies, its positiond incorrectly!!
