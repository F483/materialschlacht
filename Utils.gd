extends Node

const MASK_MAP_LEDGES = 8192
const MASK_MAP_WALLS = 16384
const MASK_MAP_SMOKE = 268435456

func get_area_owners(nodes: Array[Area2D]) -> Array[Node2D]:
    var result: Array[Node2D] = []
    for node in nodes:
        var area_owner = node.owner
        assert(area_owner is Entity, "Error: Expect area owner to be Entity!")
        result.append(area_owner)
    return result
    
func get_2dchildren(node: Node) -> Array[Node2D]:
    var result: Array[Node2D] = []
    for child in node.get_children():
        if child is Node2D:
            result.append(child)
    return result

func sort_query_world_entities(
  input_entities: Array[Dictionary]
) -> Dictionary:
    var result = {
        "player": [] as Array[Node2D],
        "enemy": [] as Array[Node2D],
        "neutral": [] as Array[Node2D],
    }
    for entry in input_entities:
        var entity = entry["collider"]
        if entity.physics_cfg.name == "Player":
            result["player"].append(entity)
        elif entity.physics_cfg.name == "Enemy":
            result["enemy"].append(entity)
        else:
            result["neutral"].append(entity)
    return result

func query_world_rect(
    world: World2D, 
    rect: Rect2, 
    collision_mask: int,
    max_results: int = 32
) -> Array[Dictionary]:
    var select_rect = RectangleShape2D.new()
    select_rect.extents = abs(rect.size) / 2
    var space = world.direct_space_state
    var parameters = PhysicsShapeQueryParameters2D.new()
    parameters.shape = select_rect
    parameters.collision_mask = collision_mask
    parameters.transform = Transform2D(0, (
        (rect.position + rect.size) + rect.position
    ) / 2)
    return space.intersect_shape(parameters, max_results)

func find_closest(node: Node2D, nodes: Array[Node2D]) -> Node2D:
    var clsoset_dist = 0
    var closest_node = null
    for other in nodes:
        var dist = node.global_position.distance_squared_to(other.global_position)
        if closest_node == null or dist < clsoset_dist:
            clsoset_dist = dist
            closest_node = other
    return closest_node

func filter_invalid(nodes: Array[Node2D]) -> Array[Node2D]:
    var result: Array[Node2D] = []
    for node in nodes:
        if is_instance_valid(node):
            result.append(node)
    return result

func filter_obscured(
    node: Node2D,
    nodes: Array[Node2D],
    check_ledges: bool,
    check_smoke: bool
) -> Array[Node2D]:
    var result: Array[Node2D] = []
    for other in nodes:
        var mask = MASK_MAP_WALLS
        if check_ledges and ((other.global_position - node.global_position).y < 0):
            mask += MASK_MAP_LEDGES
        if check_smoke:
            mask += MASK_MAP_SMOKE
        var space_state = node.get_world_2d().direct_space_state
        var query = PhysicsRayQueryParameters2D.create(
            node.global_position, 
            other.global_position,
            mask,
        )
        if not space_state.intersect_ray(query):
            result.append(other)
    return result
