extends Spatial

export(Array, PackedScene) var building_scenes: = []
export(float) var building_radius: = 0.0

var _maze: = Maze.new()

var _power_path: = []

onready var _scatter_shape: = $ScatterShape
onready var _signal_sources: = $SignalSources
onready var _buildings: = $Buildings

onready var _dialog_controller: = $DialogController


func _ready():
	_maze.generate(building_radius, _scatter_shape.polygon, 8)	
	
	for id in _maze.get_points():
		if id == _maze.start_id:
			_buildings.add_child(Spatial.new())
			continue
		var item_id = randi() % len(building_scenes)
		var rot = 15 * (randi() % 24)
		
		var inst = building_scenes[item_id].instance()
		_buildings.add_child(inst)
		inst.id = id
		inst.global_transform.origin = _maze.get_point_position(id)
		inst.rotation_degrees = Vector3(0, rot, 0)
		
		inst.connect("mouse_entered", self, "_on_building_mouse_entered", [id])
		inst.connect("mouse_exited", self, "_on_building_mouse_exited", [id])
		inst.connect("selected", self, "_power_up")
	
	# Set start and enable hover on next
	_power_up(_maze.start_id)
	
	# Set destination
	_select_destination()
	
	#TODO Cinematics


func _process(delta):
	var point0 = _maze.get_start_position() + Vector3.UP * 8
	DebugDraw.draw_box(point0, Vector3.ONE*2, Color.red)
	DebugDraw.draw_line_3d(Vector3.ZERO, point0, Color.rebeccapurple)
	for i in range(0, len(_power_path) - 1):
		var point1 = _maze.get_point_position(_power_path[i]) + Vector3.UP * 8
		var point2 = _maze.get_point_position(_power_path[i + 1]) + Vector3.UP * 8
		DebugDraw.draw_box(point1, Vector3.ONE*2, Color.red)
		DebugDraw.draw_box(point2, Vector3.ONE*2, Color.red)
		DebugDraw.draw_line_3d(point1, point2, Color.rebeccapurple)
	
	for building in _buildings.get_children():
		if building is StaticBody and building.enable_hover:
			DebugDraw.draw_box(
					building.global_transform.origin + Vector3.UP * 8,
					Vector3.ONE*2,
					Color.green
			)


func _select_destination() -> void:
	var num_possible_destinations = _signal_sources.get_child_count()
	var selected_child = _signal_sources.get_child(
			randi() % num_possible_destinations)
	_maze.set_destination_position(selected_child.global_transform.origin)
	_signal_sources.remove_child(selected_child)
	selected_child.queue_free()


func _on_building_mouse_entered(id: int) -> void:
	# TODO:
	var factor
	if _buildings.get_child(id).enable_hover:
		if id == _maze.destination_id:
			factor = _dialog_controller.Factor.CLEAN
		else:
			var optimal_steps = _maze.solution_steps
			var steps = _maze.get_steps_to_destination(id)
			if steps < optimal_steps / 3:
				factor = _dialog_controller.Factor.CORRUPT_LEVEL_1
			elif steps < 2 * optimal_steps / 3:
				factor = _dialog_controller.Factor.CORRUPT_LEVEL_2
			else:
				factor = _dialog_controller.Factor.FULL_CORRUPT
	else:
		factor = _dialog_controller.Factor.NOISE
	
	_dialog_controller.play_log(factor)


func _on_building_mouse_exited(id: int) -> void:
	_dialog_controller.stop_log()


func _power_up(id: int) -> void:
	if id == _maze.destination_id:
		yield(_dialog_controller._player, "finished")
		var continue_next_log = _dialog_controller.set_next_log()
		if continue_next_log:
			_select_destination()
	if id == _maze.start_id:
		assert(_power_path.empty())
		_power_path.push_back(id)
		_enable_next_hover(id)
	var building = _buildings.get_child(id)
	if building is StaticBody:
		building.is_active = true
		building.enable_hover = false
	# Disable prev hover
	if not _power_path.empty():
		_disable_hover(_power_path.back())
	_power_path.push_back(id)
	_enable_next_hover(id)


func _power_down() -> void:
	if not _power_path.back() == _maze.start_id:
		var id = _power_path.pop_back()
		var building = _buildings.get_child(id)
		building.is_active = false
		_disable_hover(id)
		var next_id = _power_path.back()
		_enable_next_hover(next_id)


func _enable_next_hover(id: int) -> void:
	var next_ids = _maze.get_point_connections(id)
	for next_id in next_ids:
		var building = _buildings.get_child(next_id)
		if building is StaticBody and not building.is_active:
			building.enable_hover = true
		print_debug("Hover enabled %d" % next_id)


func _disable_hover(id: int) -> void:
	var next_ids = _maze.get_point_connections(id)
	for next_id in next_ids:
		var building = _buildings.get_child(next_id)
		if building is StaticBody:
			building.enable_hover = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		_power_down()
