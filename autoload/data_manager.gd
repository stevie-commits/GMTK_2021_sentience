extends Node

const NUM_SAVE_SLOTS: = 3
const SAVE_FILE_PATH_TEMPLATE: = "user://save%d.dat"
const SAVE_DESC_LENGTH: = 30 # chars

var save_slot: = 0 setget _no_setter

var _data: = {}
var _description: = "DEFAULT"


func load_data(index: int) -> void:
	assert(index < NUM_SAVE_SLOTS, "Index greater than number of save slots!")
	save_slot = index
	var file: = File.new()
	var error = file.open(_get_save_file_path(index), File.READ)
	if not error == OK:
		return
	
	_description = file.get_line()
	_data = file.get_var()
	file.close()


func save_data() -> void:
	var file: = File.new()
	var error = file.open(_get_save_file_path(save_slot), File.WRITE)
	if not error == OK:
		push_error("Unable to open file at save slot %d" % save_slot)
		return
	
	file.store_line(_description)
	file.store_var(_data)
	file.close()


func get_save_slot_description(index: int) -> String:
	assert(index < NUM_SAVE_SLOTS, "Index greater than number of save slots!")
	save_slot = index
	var file: = File.new()
	var error = file.open(_get_save_file_path(index), File.READ)
	if not error == OK:
		return ""
	
	var result = file.get_line() 
	file.close()
	return result


func set_value(key, value) -> void:
	if (
			typeof(key) == TYPE_OBJECT
			or typeof(key) == TYPE_RID
			or typeof(value) == TYPE_OBJECT
			or typeof(value) == TYPE_RID
	):
		push_error("The key and value cannot be Objects or Resources.")
		return
	
	_data[key] = value


func get_value(key, default):
	if (
			typeof(key) == TYPE_OBJECT
			or typeof(key) == TYPE_RID
	):
		push_error("The key cannot be Objects or Resources.")
		return null
	
	if not _data.has(key):
		return default
	else:
		return _data[key]


func _get_save_file_path(index: int) -> String:
	assert(index < NUM_SAVE_SLOTS, "Index greater than number of save slots!")
	return SAVE_FILE_PATH_TEMPLATE % index


func _no_setter(_value) -> void:
	assert(false, "The property has no valid setter!!")
