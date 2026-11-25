extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var stopped :bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	animation_player.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and Global.playing:
		if stopped:
			resume()
		else:
			pause()
		
## Switchs Pause state 
func resume():
	get_tree().paused = false
	stopped = false
	visible = false
	animation_player.play_backwards("blur")

func pause():
	stopped = true
	get_tree().paused =true
	visible = true 
	animation_player.play("blur")


func _on_resume_pressed() -> void:
	resume()


func _on_reset_pressed() -> void:
	resume()
	Global.reset_game()


func _on_quit_pressed() -> void:
	get_tree().quit()
