extends Area2D

class_name Projectile

var entity_owner: Entity = null

signal physics_cfg_updated(value: PhysicsCfg)

@export var physics_cfg: PhysicsCfg = null:
    set (value):
        physics_cfg = value
        physics_cfg_updated.emit(physics_cfg)

func _ready():
    assert(entity_owner, "Entity owner not set!")
    self.physics_cfg_updated.connect(set_physics_cfg)
    set_physics_cfg(self.physics_cfg)

func set_physics_cfg(value: PhysicsCfg):
    collision_layer = value.object_layer
    collision_mask = value.object_mask
