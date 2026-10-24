extends Area2D

@export var slimeFieldScene: PackedScene
@export var explosionScene: PackedScene
var projectileType: String = "Arrow"

var direction = Vector2.ZERO
var towerMaxed = false

@export var speed: int = 500
var damage: int = 0
@export var pierceCount: int = 0
var explosionSize = Vector2(1, 1)
var slowPercent: float = 0

var hasHit: bool = false

var target : Node2D = null

func _ready() -> void:
	updateSprite()
	body_entered.connect(projectileHit)
	area_entered.connect(projectileHit)
	await get_tree().create_timer(10).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	if target != null:
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
	
	position += direction * speed * delta


func projectileHit(body: Node2D) -> void:
	if hasHit:
		return
	
	if body.is_in_group("Enemy"):
		match projectileType:
			"Arrow":
				body.get_parent().takeDamage(damage)
			"Slime":
				body.get_parent().takeDamage(damage)
				spawnSlimeField(body)
			"Cannon":
				#body.get_parent().takeDamage(damage)
				spawnExplosion()
	
	
	hasHit = true
	speed = 0
	set_deferred("monitoring", false)
	queue_free()

func spawnSlimeField(body: Node2D) -> void:
	var slimeField = slimeFieldScene.instantiate()
	var spawnPosition = body.global_position
	
	slimeField.global_position = spawnPosition
	slimeField.slowPercent = slowPercent
	
	get_tree().current_scene.call_deferred("add_child", slimeField)


func spawnExplosion() -> void:
	var explosion = explosionScene.instantiate()
	var spawnPosition = self.global_position
	
	explosion.global_position = spawnPosition
	explosion.damage = damage
	explosion.explosionSize = explosionSize
	
	get_tree().current_scene.call_deferred("add_child", explosion)


func updateSprite() -> void:
	var animatedSprite = get_node_or_null("AnimatedSprite2D")
	
	if animatedSprite == null:
		return
	
	if towerMaxed == true:
		match projectileType:
			"Arrow":
				animatedSprite.animation = "tier4 arrow"
			"Slime":
				animatedSprite.animation = "tier4 slime"
			"Cannon":
				animatedSprite.animation = "tier4 cannon"
		return
	
	
	match projectileType:
		"Arrow":
			animatedSprite.animation = "arrow"
		"Slime":
			animatedSprite.animation = "slime"
		"Cannon":
			animatedSprite.animation = "cannon"
