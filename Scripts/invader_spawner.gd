extends Node2D
class_name InvaderSpawner

#______________|Spawner Config|_________________# 
const ROWS = 5
const COLUMNS = 8
const MARGIN_H = 4
const MARGIN_V = 8


const START_POS_Y = 0
const INVADER_HEIGHT = 28
const INVADER_SPEED_Y = 10
const INVADER_SPEED_X = 20 

var move_dir = 1

const INVADER_SCENE = preload("res://Scenes/enemy.tscn")


func _ready() -> void:
	
	var invader_1_res := preload("res://Resourses/invader_1.tres")
	var invader_2_res := preload("res://Resourses/invader_2.tres")
	var invader_3_res := preload("res://Resourses/invader_3.tres")
	
	var invader_config : InvaderConfig
	
	for row in ROWS:
		if row == 0:
			invader_config = invader_3_res
		if row == 1 or row == 2:
			invader_config = invader_2_res
		if row == 3 or row == 4:
			invader_config = invader_1_res
			
		var row_width = (COLUMNS * invader_config.width * 3 ) + ((COLUMNS-1) * MARGIN_H)
		var start_x = (position.x  - row_width) / 2
		
		for col in COLUMNS:
			var x = start_x + (col* invader_config.width* 3) + (col* MARGIN_H)
			var y = START_POS_Y + (row* INVADER_HEIGHT) + (row * MARGIN_V)
			var spawn_pos = Vector2(x,y)
			spawn_invader(invader_config, spawn_pos)
		
		
	
	
	
	
	

func spawn_invader(invader_config , spawn_pos : Vector2):
	var invader : Enemy = INVADER_SCENE.instantiate()
	invader.config = invader_config
	invader.global_position = spawn_pos
	add_child(invader)
	
