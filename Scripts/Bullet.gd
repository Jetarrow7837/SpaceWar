class_name Bullet
extends Area2D

const BULLET_SCENE := preload("res://Scenes/bullet.tscn")


@onready var sprite_2d: Sprite2D = $Sprite2D

@export var speed: float = 90.0
@export var lifetime: float = 3.0
@export var faction: Global.Faction = Global.Faction.PLAYER
const damage: int = 1
var health : int = 1
var direction: Vector2 = Vector2.UP


static func shoot(pos: Vector2, dir: Vector2 = Vector2.UP, fac: Global.Faction = Global.Faction.PLAYER) -> void:
	var bullet: Bullet = BULLET_SCENE.instantiate()
	bullet.direction = dir.normalized()
	bullet.faction = fac
	var parent = Engine.get_main_loop().current_scene
	if parent == null:
		return
	parent.add_child(bullet)
	bullet.face_direction(bullet.sprite_2d , dir.normalized())
	bullet.modulate = Global.FACTION_COLORS[fac]
	bullet.global_position = pos



func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_hit(body: Node) -> void:
	if body == self:
		return
	if "faction" in body and body.faction == faction:
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func take_damage(dmg):
	health -= dmg
func face_direction(sprite: Sprite2D,dir: Vector2) -> void:
	if dir.y != 0.0:
		sprite.flip_h = dir.x < 0.0


func _on_area_entered(area: Area2D) -> void:
	if area == self:
		return
	if area is Bullet:
		area.take_damage(damage)
		destroy()
	
	
func _on_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body is Player and faction == Global.Faction.PLAYER:
		return
	elif body is Player and faction == Global.Faction.ENEMY:
		body.take_damage(damage)
		destroy()
	if body is Enemy and faction == Global.Faction.ENEMY:
		return
	elif body is Enemy and faction == Global.Faction.PLAYER:
		body.take_damage(damage)
		destroy()

func destroy():
	queue_free()
