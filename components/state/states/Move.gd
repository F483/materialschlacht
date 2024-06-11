extends State

class_name Move

@export var draw_path: bool = false

var target: Vector2 = Vector2.ZERO
var block_transition: bool = false

func enter(kwargs):
    target = kwargs["target"]
    block_transition = kwargs.get("block_transition", false)
    %Movement.target = target
    %Movement.knockback_disabled = false
    %Movement.movement_disabled = false
    %Movement.stopped.connect(_on_movement_done)
    %Movement.stuck.connect(_on_movement_done)
    %Movement.arrived.connect(_on_movement_done)
    %Movement.draw_path = draw_path
    %AnimationPlayer.play("Move")

func exit():
    %Movement.stopped.disconnect(_on_movement_done)
    %Movement.stuck.disconnect(_on_movement_done)
    %Movement.arrived.disconnect(_on_movement_done)
    %Movement.draw_path = false
    %Movement.stop()

func _on_movement_done():
    if not block_transition:
        transitioned.emit("Default", {})
