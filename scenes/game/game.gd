extends Node2D

# SETTINGS
@export var disable_spawn_enemy: bool = false
# TODO add setting_speed

# MECHANICS

## Mechanic - Highground: Bullets will hit ledges when shot upward.
@export var m_highground: bool = true

## Mechanic - Concealment: Smoke prevents vision, disabeling automatic targeting.
@export var m_concealment: bool = true

## Mechanic - Dodge Roll iframes: Units invulnerable during dodge roll.
@export var m_dodgeroll_iframes: bool = true

# TODO add m_cover
# TODO add m_player_friendly_fire
# TODO add m_enemy_friendly_fire
# TODO add m_neutral_friendly_fire
# TODO add m_jump_down_ledges
# TODO add m_light_on_heavy

# CHEATS
# TODO add c_iddqd
# TODO add c_idkfa
# TODO add c_noclip

const ENEMY_RESOURCES = {
	"Boar": preload("res://entities/enemies/boar/boar.tscn"),
}

var selected_entities: Dictionary = {}

func _ready():
	select_player_entities(%PlayerUnits.get_children())
	%MusicPlayer.play()
	
func spawn_enemy(spawn_position: Vector2 = Vector2.ZERO):
	
	var enemy_names = ENEMY_RESOURCES.keys()
	var random_index = randi() % enemy_names.size()
	var enemy_name = enemy_names[random_index]
	var enemy = ENEMY_RESOURCES[enemy_name].instantiate()
	
	if not disable_spawn_enemy:
		if spawn_position:
			enemy.global_position = spawn_position
		else:
			%PathFollow2D.progress_ratio = randf()
			enemy.global_position = %PathFollow2D.global_position
		%Enemies.add_child(enemy)

func check_game_over():
	if not %PlayerUnits.get_children():
		game_over()
		
func _physics_process(_delta):
	check_game_over()

func game_over():
	%GameOverScreen.visible = true
	get_tree().paused = true

func unselect(entity):
	var object_id = entity.get_instance_id()
	if selected_entities.has(object_id):
		var selected_entity = selected_entities[object_id]
		assert(selected_entity == entity, "ERROR: object id missmatch!")
		var selection = entity.get_node("Selection")
		selection.set_selected_off()
		return selected_entities.erase(object_id)
	return false
	
func clear_selection():
	for object_id in selected_entities:
		var entity = selected_entities[object_id]
		var selection = entity.get_node("Selection")
		selection.set_selected_off()
	selected_entities.clear()

func select_player_entities(player_entities):
	clear_selection()
	for entity in player_entities:
		var selection = entity.get_node("Selection")
		selection.set_selected_on()
		selected_entities[entity.get_instance_id()] = entity
	
func _on_selected_entities(input_entities):
	var entities_player: Array[Node2D] = []
	var entities_enemy: Array[Node2D] = []
	var entities_neutral: Array[Node2D] = []
	for entry in input_entities:
		var entity = entry["collider"]
		if entity.faction.name == "Player":
			entities_player.append(entity)
		elif entity.faction.name == "Enemy":
			entities_enemy.append(entity)
		else:
			entities_neutral.append(entity)
	if entities_player:
		select_player_entities(entities_player)
	elif entities_enemy and selected_entities:
		for object_id in selected_entities:
			var entity = selected_entities[object_id]
			entity.get_node("StateMachine").change_state(
				"Attack", {"targets": entities_enemy}
			)

func _input(event):
	if event is InputEventMouseButton:
		if event.double_click:
			for object_id in selected_entities:
				var entity = selected_entities[object_id]
				entity.get_node("StateMachine").change_state(
					"DodgeRoll", {"target": get_global_mouse_position()}
				)
		elif event.pressed and event.button_index == Config.charge_button_index:
			for object_id in selected_entities:
				var entity = selected_entities[object_id]
				entity.get_node("StateMachine").change_state("Cast", {})

func _on_selected_position(selected_position):
	if selected_entities:
		for object_id in selected_entities:
			var entity = selected_entities[object_id]
			entity.get_node("StateMachine").change_state(
				"Move", {"target": selected_position}
			)
