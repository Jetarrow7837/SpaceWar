class_name Player extends CharacterBody2D

@export var muzzle: Marker2D
@onready var fire_cooldown: Timer = $FireCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const FACTION := Global.Faction.PLAYER
const SPEED = 100.0

var lives: int = Global.START_LIVES

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("Shoot") and fire_cooldown.is_stopped():
		Bullet.shoot(muzzle.global_position, Vector2.UP, FACTION)
		fire_cooldown.start()
	
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
func take_damage(dmg):
	lives -= dmg
	if lives <= 0:
		Engine.time_scale = 0.5
		animation_player.play("death")
		await animation_player.animation_finished
		Engine.time_scale = 1
		Global.reset_game()
