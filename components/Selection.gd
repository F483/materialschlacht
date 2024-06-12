@tool

extends Node2D

class_name Selection

@export var selected: bool = true:
    set (value):
        selected = value
        queue_redraw()

@export var rect: Rect2 = Rect2(-32, -48, 64, 96)
@export var fill_color: Color = Color(1, 1 ,0 , 0.1)
@export var outline_color: Color = Color(1, 1 ,0 , 0.5)
@export var outline_width: int = 1
@export var draw_box: bool = true
@export var draw_iso: bool = true

@onready var game = get_node("/root/Game")

func _ready():
    self.tree_exiting.connect(unselect)

func set_selected_on():
    selected = true

func set_selected_off():
    selected = false

func unselect():
    game.unselect(get_parent())

func _draw():
    var tile: PackedVector2Array = [
        Vector2(
            0,
            rect.position.y + rect.size.y - rect.size.x / 2
        ),
        Vector2(
            rect.position.x, 
            rect.position.y + rect.size.y - rect.size.x / 4
        ),
        Vector2(
            0, rect.position.y + rect.size.y
        ),
        Vector2(
            rect.position.x + rect.size.x, 
            rect.position.y + rect.size.y - rect.size.x / 4
        ),
        Vector2(
            0, 
            rect.position.y + rect.size.y - rect.size.x / 2
        ),
    ]
    if selected:
        if draw_box:
            draw_rect(rect, fill_color, true)
            draw_rect(rect, outline_color, false, outline_width)
        if draw_iso:
            draw_polygon(tile, [fill_color])
            draw_polyline(tile, outline_color, outline_width, false)
