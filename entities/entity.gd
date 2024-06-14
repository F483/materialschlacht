extends CharacterBody2D

class_name Entity

@onready var game = get_node("/root/Game")
@onready var player_units = get_node("/root/Game/PlayerEntities")

signal physics_cfg_updated(value: PhysicsCfg)

@export var physics_cfg: PhysicsCfg = null:
    set (value):
        physics_cfg = value
        physics_cfg_updated.emit(physics_cfg)

func _ready():
    self.physics_cfg_updated.connect(set_physics_cfg_data)
    set_physics_cfg_data(self.physics_cfg)

func set_physics_cfg_data(value: PhysicsCfg):
    collision_layer = value.object_layer
    collision_mask = value.object_mask

func destroy():
    var death_fx = get_node("DeathFX")
    if death_fx:
        death_fx.trigger()
    queue_free()

