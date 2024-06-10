extends State

class_name AttackMove

var target: Vector2 = Vector2.ZERO

func enter(kwargs):
    target = kwargs["target"]
    %Movement.target = target
    %Movement.knockback_disabled = false
    %Movement.movement_disabled = false
    %Movement.stopped.connect(on_movement_done)
    %Movement.stuck.connect(on_movement_done)
    %Movement.arrived.connect(on_movement_done)
    
func process(_delta: float):
    # TODO hook weapon.body_entered to for transition instead, push over poll!
    var enemies = %Weapon.find_targetable_enemies()
    if enemies:
        transitioned.emit("Attack", {"targets": enemies})

func exit():
    %Movement.stopped.disconnect(on_movement_done)
    %Movement.stuck.disconnect(on_movement_done)
    %Movement.arrived.disconnect(on_movement_done)
    %Movement.stop()

func on_movement_done():
    transitioned.emit("Default", {})
