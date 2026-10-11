extends Area2D

@export var speed: int = 500
var direction = Vector2.ZERO
@export var damage: int = 10
@export var pierceCount: int = 0

var hasHit: bool = false

var target : Node2D = null

func _ready() -> void:
	body_entered.connect(bulletHit)
	await get_tree().create_timer(10).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	if target != null:
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
	
	position += direction * speed * delta


func bulletHit(body: Node2D) -> void:
	if hasHit:
		return
	
	if body.is_in_group("Enemy"):
		body.takeDamage(damage)
	
	hasHit = true
	speed = 0
	set_deferred("monitoring", false)
	
	queue_free()
