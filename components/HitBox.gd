extends Area2D

class_name HitBox

@export var dammage: float = 10.0
@export var knockback_speed: float = 500.0
@export var knockback_time: float = 0.01
@export var disabled: bool = false

signal damaged(dest_hurtbox: HurtBox)

func _ready():
    self.owner.physics_cfg_updated.connect(set_physics_cfg)
    self.area_entered.connect(_on_area_entered)
    set_physics_cfg(self.owner.physics_cfg)

func set_physics_cfg(physics_cfg: PhysicsCfg):
    collision_layer = physics_cfg.hitbox_layer
    collision_mask = physics_cfg.hitbox_mask

func _on_area_entered(hurtbox: HurtBox):
    if not disabled and not hurtbox.disabled:
        hurtbox.damaged.emit(self)
        self.damaged.emit(hurtbox)

