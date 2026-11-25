extends Node2D

@onready var high_score_lb: Label = %HighScore
@onready var score_lb: Label = %Score


func _ready() -> void:
	score_lb.text = "Score:%05d" % Global.score
	Global._load_high_score()
	high_score_lb.text = "HighScore:%05d" % Global.high_score
	Global.ScoreChanged.connect(update_score)
	
func _process(delta: float) -> void:
	pass

func update_score(scr):
		score_lb.text = "score:%05d" % scr
	
