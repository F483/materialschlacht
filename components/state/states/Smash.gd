extends State

class_name Smash

@export var duration: float = 0.1

var target: Vector2 = Vector2.ZERO
var time_lapsed: float = 0.0

# TODO activate smash hitbox

func enter(kwargs):
	target = kwargs["target"]
	%Movement.target = target
	%Movement.knockback_disabled = false
	%Movement.movement_disabled = false
	%Movement.stopped.connect(on_movement_done)
	%Movement.stuck.connect(on_movement_done)
	%Movement.arrived.connect(on_movement_done)
	%Movement.movement_speed *= 10.0
	%Movement.movement_tolerance *= 10.0
	%Sprite2D.set_texture(self.owner.SPRITES["Bash"])
	time_lapsed = 0.0

func process(delta: float):
	time_lapsed += delta
	if time_lapsed >= duration:
		transitioned.emit("Default", {})

func exit():
	%Movement.movement_speed /= 10.0
	%Movement.movement_tolerance /= 10.0
	%Movement.stopped.disconnect(on_movement_done)
	%Movement.stuck.disconnect(on_movement_done)
	%Movement.arrived.disconnect(on_movement_done)
	%Movement.stop()

func on_movement_done():
	transitioned.emit("Default", {})
