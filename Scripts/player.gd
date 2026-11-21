class_name Player extends CharacterBody2D

@export var muzzle: Marker2D
@onready var fire_cooldown: Timer = $FireCooldown

const FACTION := Global.Faction.PLAYER
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

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
	Global.lives_changed.emit()
	
	
	
