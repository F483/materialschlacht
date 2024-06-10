extends State

class_name Secondary

@export var line_color: Color = Color(1, 0 ,0 , 1)
@export var line_width: int = 1

var charging: bool = false
var charge_time: float = 0.0

func enter(_kwargs):
    %Movement.knockback_disabled = true
    %Movement.movement_disabled = true
    %Movement.stop()
    charging = true
    charge_time = 0.0
    queue_redraw()

func _input(event):
    if charging:
        if event is InputEventMouseButton:
            if event.button_index == Config.secondary_button_index and not event.pressed:
                print("TODO emit secondary release event")
            else:
                print("TODO emit secondary cancelled event")
            transitioned.emit("Default", {})
            queue_redraw()

func process(delta: float):
    if charging:
        charge_time += delta
        queue_redraw()

func _draw():
    if charging:
        draw_line(
            Vector2.ZERO, 
            get_global_mouse_position() - self.owner.global_position, 
            line_color, 
            line_width, 
            false
        )

func exit():
    %Movement.movement_disabled = false
    %Movement.knockback_disabled = false
    charging = false
    queue_redraw()
