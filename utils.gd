extends Node

const MASK_MAP_LEDGES = 8192
const MASK_MAP_WALLS = 16384
const MASK_MAP_SMOKE = 268435456

func get_2dchildren(node: Node) -> Array[Node2D]:
	var result: Array[Node2D] = []
	for child in node.get_children():
		if child is Node2D:
			result.append(child)
	return result

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
