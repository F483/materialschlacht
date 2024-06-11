extends Area2D

class_name HitBox

@export var dammage: float = 10.0
@export var knockback_speed: float = 500.0
@export var knockback_time: float = 0.01
@export var disabled: bool = false

signal damaged(dest_hurtbox: HurtBox)

func _ready():
    self.owner.faction_updated.connect(set_faction_data)
    self.area_entered.connect(_on_area_entered)
    set_faction_data(self.owner.faction)

func set_faction_data(faction: Faction):
    collision_layer = faction.hitbox_layer
    collision_mask = faction.hitbox_mask

func _on_area_entered(hurtbox: HurtBox):
    if not disabled and not hurtbox.disabled:
        hurtbox.damaged.emit(self)
        self.damaged.emit(hurtbox)
