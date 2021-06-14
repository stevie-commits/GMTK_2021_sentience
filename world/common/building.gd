extends StaticBody

signal selected(id)

var is_active: = false
var id: int

var enable_hover: = false


func _input_event(camera, event, click_position, click_normal, shape_idx):
	if not enable_hover:
		return
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		emit_signal("selected", id)
