extends Area2D

class_name HurtBox

signal damaged(src_hitbox: HitBox)

@export var disabled: bool = false

func _ready():
	self.owner.faction_updated.connect(set_faction_data)
	set_faction_data(self.owner.faction)

func set_faction_data(faction: Faction):
	collision_layer = faction.hurtbox_layer
	collision_mask = faction.hurtbox_mask
