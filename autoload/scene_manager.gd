extends Node

const WorldController: = preload("res://world/common/world_controller.tscn")
const GameOver: = preload("res://ui/menus/game_over_screen/game_over.tscn")

onready var loading_screen: = $LoadingScreen


func load_game(save_slot: int):
	var result = loading_screen.show()
	if result is GDScriptFunctionState:
		yield(result, "completed")
	
	DataManager.load_data(save_slot)
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(WorldController)
	yield(get_tree(), "idle_frame")
	result = get_tree().current_scene.initialize()
	if result is GDScriptFunctionState:
		yield(result, "completed")
	
	result = loading_screen.hide()
	if result is GDScriptFunctionState:
		yield(result, "completed")


func victory():
	var result = loading_screen.show()
	if result is GDScriptFunctionState:
		yield(result, "completed")
	
	get_tree().change_scene_to(GameOver)
	yield(get_tree(), "idle_frame")
	
	result = loading_screen.hide()
	if result is GDScriptFunctionState:
		yield(result, "completed")


func quit_game():
	if not OS.get_name() == "HTML5":
		get_tree().quit()
