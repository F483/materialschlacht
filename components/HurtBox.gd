extends Area2D

class_name HurtBox

signal damaged(src_hitbox: HitBox)

@export var disabled: bool = false

func _ready():
    self.owner.physics_cfg_updated.connect(set_physics_cfg)
    set_physics_cfg(self.owner.physics_cfg)

func set_physics_cfg(physics_cfg: PhysicsCfg):
    collision_layer = physics_cfg.hurtbox_layer
    collision_mask = physics_cfg.hurtbox_mask
