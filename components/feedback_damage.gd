extends Node2D

signal dealt_feedback(entity: Entity, amount: float)

@export var factor: float = 2.0
@export var disabled: bool = false

func on_damaged(src_hitbox: HitBox):
	if not disabled:
		var owner_class = src_hitbox.entity_owner.get_class()
		assert(
			src_hitbox.entity_owner is Entity,
			"Unexpected hitbox owner type: %s" % owner_class
		)
		var owner_health_bar = src_hitbox.entity_owner.get_node('HealthBar')
		assert(
			owner_health_bar is HealthBar,
			"Expected %s to have 'HealthBar'" % owner_class
		)
		var feedback_damage = - src_hitbox.dammage * factor
		var dammage_dealt = owner_health_bar.change(feedback_damage)
		dealt_feedback.emit(src_hitbox.entity_owner, dammage_dealt)
