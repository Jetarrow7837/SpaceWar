extends Node
#region Signals
signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
#signal level_changed(new_level: int)
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
		high_score = value
		high_score_changed.emit(high_score)


#
#var level: int = 1:
	#set(value):
		#level = value
		#level_changed.emit(level)

var playing: bool = false
#endregion

func _ready() -> void:
	lives_changed.connect(update_lives)
	game_started.connect(start_game)
	game_over.connect(reset_game)
	score_changed.connect(update_score)
	high_score_changed.connect(update_highscore)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_high_score()

func update_lives(new_lives):
	pass

func update_highscore(new_hscore):
	high_score = new_hscore
	_save_high_score()


func update_score(scr):
	score += scr
	
func start_game():
	get_tree().change_scene_to_file(Global.GAME_SCENE)

func reset_game():
	get_tree().reload_current_scene()


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
