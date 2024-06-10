extends Node2D

class_name SelectionBox

signal selected_entities(value: Array[Dictionary])
signal selected_position(value: Vector2)

@export_flags_2d_physics var collision_mask: int = 0
@export var box_fill_color: Color = Color(0, 1 ,0 , 0.1)
@export var box_outline_color: Color = Color(0, 1 ,0 , 1)
@export var box_outline_width: int = 1

var dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var drag_end: Vector2 = Vector2.ZERO

func reset():
	dragging = false
	drag_start = Vector2.ZERO
	drag_end = Vector2.ZERO
	
func _input(event):
	if event is InputEventMouseButton:
		if event.double_click:
			reset() # drop selection on double click, used for special
		elif event.button_index != Config.select_button_index:
			reset() # drop selection on other buttons, used for charge
		elif event.pressed:
			dragging = true
			drag_start = event.position
			drag_end = event.position
		elif dragging and not event.pressed:
			drag_end = event.position
			do_selection()
			reset()
		queue_redraw()
	elif event is InputEventMouseMotion and dragging:
		drag_end = event.position
		queue_redraw()

func _process(delta):
	if dragging:
		queue_redraw()

func _draw():
	if dragging:
		var rect = get_selecton_rect(false)
		draw_rect(rect, box_fill_color, true)
		draw_rect(rect, box_outline_color, false, box_outline_width)

func get_selecton_rect(global: bool) -> Rect2:
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

func do_selection():
	var global_rect = get_selecton_rect(true)
	var selected = Utils.query_world_rect(
		get_world_2d(), global_rect, collision_mask
	)
	if selected:
		selected_entities.emit(Utils.sort_query_world_entities(selected))
	else:
		var point = global_rect.position + global_rect.size / 2
		selected_position.emit(point)
