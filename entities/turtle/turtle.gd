extends CharacterBody2D

@onready var player = get_node("/root/Game/MiniBull") # FIXME get nearest player unit instead

func _physics_process(_delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 100.0
		move_and_slide()
