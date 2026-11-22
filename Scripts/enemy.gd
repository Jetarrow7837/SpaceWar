class_name Enemy extends CharacterBody2D
@onready var collider: CollisionShape2D = $CollisionShape2D
var config : InvaderConfig
@onready var sprite: Sprite2D = $Sprite2D


var health = 1:
	set(value):
		health = value
		if health <= 0: 
			queue_free()
const SPEED = 100.0
const FACTION := Global.Faction.ENEMY



static var direction := Vector2.RIGHT


var size_half : int
var step_timer := 0.0

@onready var muzzle: Marker2D = $Muzzle


func _ready() -> void:
	if config:
		sprite.texture = config.sprite
	
	size_half = collider.shape.get_rect().size.x /2 + 2


func _physics_process(delta: float) -> void:
	pass
	#if position.x >= get_viewport_rect().size.x - size_half:
		#position.y += size_half * delta
		#direction= -direction 
	#if position.x <= get_viewport_rect().position.x + size_half:
		#position.y += size_half *delta
		#direction= -direction 
		
func fire():
	Bullet.shoot(muzzle.global_position,Vector2.DOWN,FACTION)

func take_damage(damage):
	health -= damage
	print(health)
