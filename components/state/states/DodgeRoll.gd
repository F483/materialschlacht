extends State

class_name DodgeRoll

@export var factor: float = 10.0
@export var duration: float = 0.1

var ttl: float = 0.0
var target: Vector2 = Vector2.ZERO

func enter(kwargs):
	target = kwargs["target"]
	ttl = duration
	%Movement.target = target
	%Movement.knockback_disabled = false
	%Movement.movement_disabled = false
	%Movement.stopped.connect(on_movement_done)
	%Movement.stuck.connect(on_movement_done)
	%Movement.arrived.connect(on_movement_done)
	%Movement.movement_speed *= factor
	%AnimationPlayer.play("Walk")
	if self.owner.game.m_dodgeroll_iframes:
		%HurtBox.disabled = true

func physics_process(delta: float):
	ttl -= delta
	if ttl <= 0.0:
		transitioned.emit("Move", {"target": target})

func exit():
	%Movement.movement_speed /= factor
	%Movement.stopped.disconnect(on_movement_done)
	%Movement.stuck.disconnect(on_movement_done)
	%Movement.arrived.disconnect(on_movement_done)
	if self.owner.game.m_dodgeroll_iframes:
		%HurtBox.disabled = false
		
func on_movement_done():
	transitioned.emit("Default", {})
