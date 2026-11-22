extends Node2D
class_name InvaderSpawner

#______________|Spawner Config|_________________# 
const ROWS = 5
const COLUMNS = 8
const MARGIN_H = 8
const MARGIN_V = 8


const START_POS_Y = 30
const INVADER_HEIGHT = 15
const INVADER_SPEED_Y = 10
const INVADER_SPEED_X = 15 

var move_dir = 1

const INVADER_SCENE = preload("res://Scenes/enemy.tscn")
@onready var movement_timer: Timer = $MovementTimer
@onready var shoot_timer: Timer = $ShootTimer


func _ready() -> void:
	shoot_timer.timeout.connect(shoot_invader)
	movement_timer.timeout.connect(move_invader)
	var SCREEN_WIDTH := get_viewport_rect().size.x
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
			
		#var row_width = (COLUMNS * invader_config.width * 3 ) + ((COLUMNS-1) * MARGIN_H)
		#var start_x = (position.x  - row_width) / 2
		var w := invader_config.width * 3
		var row_width := COLUMNS * w + (COLUMNS - 1) * MARGIN_H
		var start_x := (SCREEN_WIDTH - row_width) / 2.0 + w / 2.0   # + w/2 for centered sprites

		for col in COLUMNS:
			var x = start_x + (col* w) + (col* MARGIN_H)
			var y = START_POS_Y + (row* INVADER_HEIGHT) + (row * MARGIN_V)
			var spawn_pos = Vector2(x,y)
			spawn_invader(invader_config, spawn_pos)

func spawn_invader(invader_config , spawn_pos : Vector2):
	var invader : Enemy = INVADER_SCENE.instantiate()
	invader.config = invader_config
	invader.position = spawn_pos
	add_child(invader)
	

func move_invader():
	position.x += INVADER_SPEED_X * move_dir

func shoot_invader():
	var rand_invader : Enemy = get_children().filter(func(child): return child is Enemy).pick_random()
	if rand_invader:
		rand_invader.fire()
func _on_wall_left_body_entered(body: Node2D) -> void:
	if body is Enemy and move_dir == -1 :
		position.y += INVADER_SPEED_Y
		move_dir = -move_dir


func _on_wall_right_body_entered(body: Node2D) -> void:
	if body is Enemy and move_dir == 1 :
		position.y += INVADER_SPEED_Y
		move_dir = -move_dir
