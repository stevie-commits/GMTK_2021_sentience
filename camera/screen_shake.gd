extends Node

export (float, 0.0, 1.0) var stress_decay_rate: = 5.0
export (Vector3) var max_rotation: = Vector3(25.0, 25.0, 25.0)

var _stress: = 0.0
var _noise: = OpenSimplexNoise.new()

onready var _camera: Camera = get_parent()
onready var _default_translation: = _camera.translation


func _process(delta):
	if is_zero_approx(_stress):
		set_process(false)
	
	var amplitude = _stress * _stress
	_camera.rotation_degrees += Vector3(
			max_rotation.x * amplitude * _get_shake_noise(delta),
			max_rotation.y * amplitude * _get_shake_noise(delta),
			max_rotation.z * amplitude * _get_shake_noise(delta)
	)
	
	_stress = max(_stress - stress_decay_rate * delta, 0.0)


func add_stress(amount: float):
	_stress = min(_stress + amount, 1.0)
	if _stress > 0:
		set_process(true)


func _get_shake_noise(delta: float):
	_noise.seed = randi()
	_noise.octaves = 4
	_noise.period = 20.0
	_noise.persistence = 0.8
	
	return _noise.get_noise_1d(delta)
