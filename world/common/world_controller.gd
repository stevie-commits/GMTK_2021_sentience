extends Node

export(Array, String) var level_paths: = [
	"res://world/level_01/level_01.tscn"
]

var _current_level


func initialize():
	_current_level = load(level_paths[0])
	add_child(_current_level.instance())
	
