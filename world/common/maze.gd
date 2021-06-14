class_name Maze
extends AStar

var num_points: = 0
var start_id: = 0 setget _no_setter
var destination_id setget _no_setter

var solution_steps: = 0


func get_start_position() -> Vector3:
	return get_point_position(start_id)


func set_destination_position(position: Vector3) -> void:
	destination_id = get_closest_point(position)
	solution_steps = len(get_id_path(start_id, destination_id))


func get_destination_position() -> Vector3:
	return get_point_position(destination_id)


func get_steps_to_destination(from_id: int) -> int:
	return len(get_id_path(from_id, destination_id))


func generate(radius: float, sample_region_shape, retries: int):
	# Recursive Backtracker
	clear()
	randomize()
	
	# Sample the space
	var sampler: = PoissonDiscSampler.new()
	var points: = sampler.generate_points(radius, sample_region_shape, retries)
	assert(not points.empty())
	print_debug("Points Generated.")
	points.push_front(Vector2.ZERO)
	num_points = len(points)
	
	var visited_status: = []
	visited_status.resize(num_points)
	var stack: = []
	
	# Add all points to the graph
	var neighbours: = {}
	for id in len(points):
		visited_status[id] = false
		add_point(id, Vector3(points[id].x, 0, points[id].y))
		neighbours[id] = []
	
	# Triangulate them for connectivity.
	var tris = Geometry.triangulate_delaunay_2d(PoolVector2Array(points))
	assert(not tris.empty())
	for index in range(0, len(tris), 3):
		if not tris[index + 1] in neighbours[tris[index]]:
			neighbours[tris[index]].append(tris[index + 1])
		if not tris[index] in neighbours[tris[index + 1]]:
			neighbours[tris[index + 1]].append(tris[index])
		if not tris[index + 2] in neighbours[tris[index]]:
			neighbours[tris[index]].append(tris[index + 2])
		if not tris[index] in neighbours[tris[index + 2]]:
			neighbours[tris[index + 2]].append(tris[index])
		if not tris[index + 2] in neighbours[tris[index + 1]]:
			neighbours[tris[index + 1]].append(tris[index + 2])
		if not tris[index + 1] in neighbours[tris[index + 2]]:
			neighbours[tris[index + 2]].append(tris[index + 1])
	
	print_debug("Neighbours connected.")
	
	var curr_id = 0
	visited_status[0] = true
	var num_visited = 1
	while num_visited != num_points:
		var unvisited_neighbours = _check_neighbors(
				neighbours[curr_id], visited_status)
		if unvisited_neighbours.size() > 0:
			var next_id = unvisited_neighbours[randi() % unvisited_neighbours.size()]
			stack.append(curr_id)
			connect_points(curr_id, next_id)
			curr_id = next_id
			visited_status[curr_id] = true
			num_visited += 1

		elif not stack.empty():
			curr_id = stack.pop_back()
	
#	start_id = get_closest_point(Vector3.ZERO)


# returns a list of its unvisited neighbors
func _check_neighbors(neighbours: Array, visited_status: Array) -> Array:
	# returns an array of cell's unvisited neighbors
	var list = []
	for id in neighbours:
		if not visited_status[id]:
			list.append(id)
	return list


func _no_setter(_value) -> void:
	assert(false, "The property has no valid setter!!")
