extends ProgressBar

class_name HealthBar

signal health_changed(amount: float)
signal health_damaged(amount: float)
signal health_healed(amount: float)
signal health_depleted
signal health_recovered

@export var disabled: bool = false
@export var invulnerable: bool = false

func heal(amount: float):
    return change(abs(amount))

func on_damaged(src_hitbox: HitBox):
    if invulnerable:
        return 0.0
    return change(-abs(src_hitbox.dammage))

func change(amount: float):
    if disabled or amount == 0.0:
        return 0.0
    var next = clamp(value + amount, min_value, max_value)
    var delta = next - value
    value = next
    health_changed.emit(delta)
    if value == 0.0:
        health_depleted.emit()
    if value == max_value:
        health_recovered.emit()
    if delta < 0.0:
        health_damaged.emit(delta)
    if delta > 0.0:
        health_healed.emit(delta)
    return delta
