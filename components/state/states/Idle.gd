extends State

class_name Idle  # TODO rename to Hold everywhere

func enter(_kwargs):
    %Movement.knockback_disabled = true
    %Movement.movement_disabled = true
    %Movement.stop()
    %AnimationPlayer.play("Idle")

func process(_delta: float):
    var enemies = %Weapon.find_targetable_enemies()
    if enemies.size() > 0:
        transitioned.emit("Defend", {"enemies": enemies})

func exit():
    %Movement.movement_disabled = false
    %Movement.knockback_disabled = false
