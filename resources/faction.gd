extends Resource

class_name Faction

@export var name: String = "Neutral"

@export var color_primary: Color = Color(1,1,1,1)
@export var color_secondary: Color = Color(1,1,1,1)

@export_flags_2d_physics var object_layer: int = 0
@export_flags_2d_physics var object_mask: int = 0

@export_flags_2d_physics var hitbox_layer: int = 0
@export_flags_2d_physics var hitbox_mask: int = 0

@export_flags_2d_physics var hurtbox_layer: int = 0
@export_flags_2d_physics var hurtbox_mask: int = 0

@export_flags_2d_physics var targeting_layer: int = 0
@export_flags_2d_physics var targeting_mask: int = 0
