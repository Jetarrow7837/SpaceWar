extends Node

signal ScoreChanged(score)

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
		ScoreChanged.emit(score)
		if score > high_score:
			high_score = score


var high_score: int = 0:
	set(value):
		if value == high_score:
			return
		high_score = value
		_save_high_score()

var playing: bool = false
#endregion

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_high_score()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_high_score()

func add_score(points: int) -> void:
	score += points

	
func start_game() -> void:
	playing = true
	reset_game()
	get_tree().change_scene_to_file(GAME_SCENE)

func reset_game() -> void:
	playing = true
	Engine.time_scale = 1
	score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
	


#____________________________________________________________________________#





#region SaveManager
##needs high_score VAR 
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
