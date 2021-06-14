# This is the entry point for our game.
extends Control

# warning-ignore:unused_signal
# Called by the animation player.
signal screen_transition

enum Screen {
	TITLE,
#	GAME_SELECT,
	SETTINGS,
	CREDITS
}

onready var _menu_tabs: = $MenuTabs
onready var _title_screen: = $MenuTabs/TitleScreen
onready var _settings_screen: = $MenuTabs/SettingsScreen
#onready var _game_select_screen: = $MenuTabs/GameSelectScreen
onready var _credits_screen: = $MenuTabs/CreditsScreen
onready var _anim_player: = $TransitionPlayer


func _ready():
	_title_screen.connect_play_game(self, "_on_play_game_pressed")
	_title_screen.connect_settings(self, "_on_settings_pressed")
	_title_screen.connect_credits(self, "_on_credits_pressed")
	_settings_screen.connect_back(self, "_on_back_pressed")
#	_game_select_screen.connect_back(self, "_on_back_pressed")
	_credits_screen.connect_back(self, "_on_back_pressed")
	$BackgroundAudio.play()


func _on_play_game_pressed():
	SceneManager.load_game(0)


func _on_settings_pressed():
	_anim_player.play("screen_transition")
	yield(self, "screen_transition")
	_menu_tabs.current_tab = Screen.SETTINGS


func _on_credits_pressed():
	_anim_player.play("screen_transition")
	yield(self, "screen_transition")
	_menu_tabs.current_tab = Screen.CREDITS


func _on_back_pressed():
	_anim_player.play("screen_transition")
	yield(self, "screen_transition")
	_menu_tabs.current_tab = Screen.TITLE


func _disable_input() -> void:
	# called from the animation player.
	get_viewport().gui_disable_input = true


func _enable_input() -> void:
	# called from the animation player.
	get_viewport().gui_disable_input = false
