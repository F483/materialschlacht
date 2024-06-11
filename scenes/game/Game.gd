extends Node2D

class_name Game

# SETTINGS
@export var disable_spawn_enemy: bool = true
# TODO add setting_speed

# MECHANICS

## Mechanic - Highground: Bullets will hit ledges when shot upward.
@export var m_highground: bool = true

## Mechanic - Concealment: Smoke prevents vision, disabeling automatic targeting.
@export var m_concealment: bool = true

## Mechanic - Dodge Roll iframes: Units invulnerable during dodge roll.
@export var m_dodgeroll_iframes: bool = true

enum INPUT_MODE { 
    BOX_SELECT, 
    DRAG_SELECT  # FIXME factor out drag select into its own file
}
@export var input_mode: INPUT_MODE = INPUT_MODE.BOX_SELECT

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
    # FIXME set camera limits based on map size
    
func spawn_enemy(spawn_position: Vector2 = Vector2.ZERO):
    if disable_spawn_enemy:
        return # FIXME enable and add objective destructable spawn nodes to map
        
    var enemy_names = ENEMY_RESOURCES.keys()
    var random_index = randi() % enemy_names.size()
    var enemy_name = enemy_names[random_index]
    var enemy = ENEMY_RESOURCES[enemy_name].instantiate()
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
    if input_mode == INPUT_MODE.DRAG_SELECT:
        for object_id in selected_entities:
            var entity = selected_entities[object_id]
            var move_state = entity.get_node("StateMachine").get_node("Move")
            var movement = entity.get_node("Movement")
            move_state.target = get_global_mouse_position()
            movement.target = get_global_mouse_position()
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
    if input_entities["player"]:
        select_player_entities(input_entities["player"])
    elif input_entities["enemy"] and selected_entities:
        for object_id in selected_entities:
            var entity = selected_entities[object_id]
            entity.get_node("StateMachine").change_state(
                "Attack", {"targets": input_entities["enemy"]}
            )

func _change_state(name, kwargs):
    for object_id in selected_entities:
        var entity = selected_entities[object_id]
        entity.get_node("StateMachine").change_state(name, kwargs)

func _input(event):
    if event is InputEventMouseButton:

        if (
            input_mode == INPUT_MODE.DRAG_SELECT
            and event.button_index == Config.select_button_index
            and not event.pressed 
        ):
            for object_id in selected_entities:
                var entity = selected_entities[object_id]
                var move_state = entity.get_node("StateMachine").get_node("Move")
                move_state.block_transition = false
            %SelectionBox.disabled = false
            input_mode = INPUT_MODE.BOX_SELECT
            return

        if event.double_click:
            _change_state("DodgeRoll", {"target": get_global_mouse_position()})
            return

        if (
            event.button_index == Config.secondary_button_index
            and event.pressed
        ):
            # FIXME how to differentiate between draging on mobile!!!
            #       hold over ~same spot for time?
            _change_state("Secondary", {})
            return

        if (
            event.button_index == Config.select_button_index
            and event.pressed 
        ):
            var global_rect = Rect2(get_global_mouse_position(), Vector2(1, 1))
            var selected = Utils.query_world_rect(
                get_world_2d(), global_rect, %SelectionBox.collision_mask
            )
            if selected:
                var entities = Utils.sort_query_world_entities(selected)
                
                if entities["player"]:
                    select_player_entities(entities["player"])
                    _change_state("Move", {
                        "target": get_global_mouse_position(),
                        "block_transition": true
                    })
                    %SelectionBox.disabled = true
                    input_mode = INPUT_MODE.DRAG_SELECT
                    return
                    
                elif entities["enemy"] and selected_entities:
                    # TODO implement attack with current selection
                    return
        
        if (input_mode == INPUT_MODE.DRAG_SELECT):
            %SelectionBox.disabled = false
            input_mode = INPUT_MODE.BOX_SELECT
            _change_state("Default", {})
            return

func _on_selected_position(selected_position):
    if selected_entities:
        for object_id in selected_entities:
            var entity = selected_entities[object_id]
            entity.get_node("StateMachine").change_state(
                "Move", {"target": selected_position}
            )
