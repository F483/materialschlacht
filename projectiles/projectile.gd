extends Area2D

class_name Projectile

var entity_owner: Entity = null

signal faction_updated(value: Faction)

@export var faction: Faction = null:
    set (value):
        faction = value
        faction_updated.emit(faction)

func _ready():
    assert(entity_owner, "Entity owner not set!")
    self.faction_updated.connect(set_faction_data)
    set_faction_data(self.faction)

func set_faction_data(value: Faction):
    collision_layer = value.object_layer
    collision_mask = value.object_mask
