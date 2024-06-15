extends Node2D

class_name SelectionBox # TODO rename to InputSelectionBox to avoid confusion

signal selected_entities(value: Array[Dictionary])
signal selected_position(value: Vector2)

@export_flags_2d_physics var collision_mask: int = 0
@export var box_fill_color: Color = Color(1, 1 ,0 , 0.1)
@export var box_outline_color: Color = Color(1, 1 ,0 , 0.5)
@export var box_outline_width: int = 1

@export var disabled: bool = false:
    set (value):
        disabled = value
        _reset()

var dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var drag_end: Vector2 = Vector2.ZERO

func _reset():
    dragging = false
    drag_start = Vector2.ZERO
    drag_end = Vector2.ZERO
    queue_redraw()
    
func _input(event):
    if disabled:
        return
    if event is InputEventMouseButton:
        if event.double_click:
            _reset() # drop selection on double click, used for special
        elif event.button_index != Config.select_button_index:
            _reset() # drop selection on other buttons, used for charge
        elif event.pressed:
            dragging = true
            drag_start = event.position
            drag_end = event.position
            queue_redraw()
        elif dragging and not event.pressed:
            drag_end = event.position
            _do_selection()
            _reset()
    elif event is InputEventMouseMotion and dragging:
        drag_end = event.position
        queue_redraw()

func _process(delta):
    if disabled:
        return
    if dragging:
        queue_redraw()

func _draw():
    if disabled:
        return
    if dragging:
        var rect = _get_selecton_rect(false)
        draw_rect(rect, box_fill_color, true)
        draw_rect(rect, box_outline_color, false, box_outline_width)

func _get_selecton_rect(global: bool) -> Rect2:
    var viewport_rect = get_viewport().get_visible_rect()
    var viewport_offset = viewport_rect.size / 2
    var camera_offset = (
        %Camera2D.get_screen_center_position() - %Camera2D.global_position
    )
    if global:
        return Rect2(
            drag_start + camera_offset + global_position - viewport_offset, 
            drag_end - drag_start
        )
    else:
        return Rect2(
            drag_start + camera_offset - viewport_offset, 
            drag_end - drag_start
        )

func _do_selection():
    if disabled:
        return
    var global_rect = _get_selecton_rect(true)
    var selected = Utils.query_world_rect(
        get_world_2d(), global_rect, collision_mask
    )
    if selected:
        selected_entities.emit(Utils.sort_query_world_entities(selected))
    else:
        var point = global_rect.position + global_rect.size / 2
        selected_position.emit(point)
