extends Node
#region Signals
signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)
signal game_over
signal game_started
signal game_paused(is_paused: bool)
#endregion

enum Faction { PLAYER, ENEMY }

const FACTION_COLORS := {
	Faction.PLAYER: Color(0.0, 1.0, 0.0, 1.0),
	Faction.ENEMY: Color(1.0, 0.4, 0.4),
}

const START_LIVES := 3
const SAVE_PATH := "user://invaders_save.json"
const MAIN_MENU_SCENE := "res://main_menu.tscn"   # change to your scenes
const GAME_SCENE := "uid://cve4lm6negv7q"

#region Variables

var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)
		if score > high_score:
			high_score = score


var high_score: int = 0:
	set(value):
		if value == high_score:
			return
		high_score = value
		high_score_changed.emit(high_score)

var playing: bool = false
#endregion

func _ready() -> void:
	game_started.connect(start_game)
	game_over.connect(reset_game)
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_high_score()
#
#func update_lives(new_lives):
	#pass

func update_highscore(new_hscore):
	high_score = new_hscore
	_save_high_score()

func add_score(points: int) -> void:
	score += points
	
func update_score(scr):
	score += scr
	
func start_game() -> void:
	playing = true
	get_tree().change_scene_to_file(GAME_SCENE)
	_reset_run()

func reset_game() -> void:
	playing = true
	_reset_run()
	_save_high_score()
	get_tree().reload_current_scene()
	
func _reset_run() -> void:
	Engine.time_scale = 1
	score = 0
	get_tree().paused = false

#____________________________________________________________________________#

func _unhandled_input(event: InputEvent) -> void: 
	if playing and event.is_action_pressed("Pause"): #Pauses the Game
		toggle_pause()

## Switchs Pause state 
func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	game_paused.emit(get_tree().paused)
	print("Paused")


#region SaveManager
#accecs highscore var
func _save_high_score() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({"high_score": high_score}))

func _load_high_score() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) == TYPE_DICTIONARY:
		high_score = int(data.get("high_score", 0))
#endregion
