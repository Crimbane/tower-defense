extends Area2D

@export var iceFieldScene: PackedScene
var projectileType: String = "Arrow"

var direction = Vector2.ZERO

@export var speed: int = 500
var damage: int = 10
@export var pierceCount: int = 0

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
			"Ice":
				body.get_parent().takeDamage(damage)
				spawnIceField()
				
	
	
	hasHit = true
	speed = 0
	set_deferred("monitoring", false)
	queue_free()

func spawnIceField() -> void:
	var iceField = iceFieldScene.instantiate()
	var spawnPosition = self.global_position
	
	iceField.global_position = spawnPosition
	
	get_tree().current_scene.call_deferred("add_child", iceField)

func updateSprite() -> void:
	var animatedSprite = get_node_or_null("AnimatedSprite2D")
	
	if animatedSprite == null:
		return
	
	match projectileType:
		"Arrow":
			animatedSprite.animation = "arrow"
		"Ice":
			animatedSprite.animation = "ice"
