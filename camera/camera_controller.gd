extends Spatial

export(float) var move_speed: = 50
export(float) var move_weight: = 3.2
export(float) var rotate_speed: = 1
export(float) var rotate_weight: = 5.1
export(Vector3) var up_dir: = Vector3.UP

var _move_velocity: = Vector3.ZERO
var _rotate_velocity: = 0.0

onready var _camera_arm: = $Arm
onready var _camera: = $Arm/Camera

func _process(delta):
	var orientaion: Basis = _camera_arm.global_transform.basis
	# Use -ve since camera faces -ve z direction
	var longitudinal_dir: = -Vector3(orientaion.z.x, 0.0, orientaion.z.z)
	var lateral_dir: Vector3 = orientaion.x
	var dir = (Input.get_action_strength("camera_forward")\
			- Input.get_action_strength("camera_backward")) * longitudinal_dir\
			+ (Input.get_action_strength("camera_right")\
			- Input.get_action_strength("camera_left")) * lateral_dir
	
	var ang_dir = Input.get_action_strength("camera_anticlockwise")\
			- Input.get_action_strength("camera_clockwise")
	
	_update_movement(move_speed * dir, delta)
	_update_rotation(rotate_speed * ang_dir, delta)


func _update_movement(move_delta: Vector3, time_delta: float) -> void:
	var n1 = _move_velocity\
			+ move_delta * (move_weight * move_weight) * time_delta
	var n2 = 1 + move_weight * time_delta
	
	_move_velocity = n1 / (n2 * n2)
	translate(_move_velocity * time_delta)


func _update_rotation(rot_delta: float, time_delta: float) -> void:
	var n1 = _rotate_velocity\
			+ rot_delta * (rotate_weight * rotate_weight) * time_delta
	var n2 = 1 + rotate_weight * time_delta
	
	_rotate_velocity = n1 / (n2 * n2)
	_camera_arm.rotate(up_dir, _rotate_velocity * time_delta)
