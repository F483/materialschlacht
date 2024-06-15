@tool

extends Area2D

class_name SelectBox

@export var selected: bool = true:
    set (value):
        selected = value
        queue_redraw()

@export var rect: Rect2 = Rect2(-32, -48, 64, 96) # FIXME get from shape instead
@export var fill_color: Color = Color(1, 1 ,0 , 0.25)
@export var outline_color: Color = Color(1, 1 ,0 , 1)
@export var outline_width: int = -1
@export var draw_iso: bool = true
@export var alt_owner: Node = null

func _ready():
    if not Engine.is_editor_hint():
        alt_owner = self.owner
        self.owner.physics_cfg_updated.connect(set_physics_cfg)
        self.tree_exiting.connect(unselect)
        set_physics_cfg(self.owner.physics_cfg)

func set_physics_cfg(physics_cfg: PhysicsCfg):
    collision_layer = physics_cfg.selectbox_layer
    collision_mask = physics_cfg.selectbox_mask

func unselect():
    # FIXME Known bug: https://github.com/godotengine/godot/issues/92769
    # self.owner.game.unselect(self.owner)
    self.alt_owner.game.unselect(self.alt_owner)
    
func set_selected_on():
    selected = true

func set_selected_off():
    selected = false
    
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
    if selected and draw_iso:
        draw_polygon(tile, [fill_color])
        draw_polyline(tile, outline_color, outline_width, false)
