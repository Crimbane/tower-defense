extends Area2D

@export var collisionShape: CollisionShape2D
@export var particles1: GPUParticles2D
@export var particles2: GPUParticles2D
@export var particles3: GPUParticles2D

var damage: int = 0
var explosionSize = Vector2(1.0, 1.0)

func _ready() -> void:
	collisionShape.scale = explosionSize
	await get_tree().physics_frame
	var enemies = get_overlapping_areas()
	
	#var enemy = area.get_parent()
	for enemy in enemies:
		if enemy.is_in_group("Enemy"):
			enemy.get_parent().takeDamage(damage)
	
	particles1.amount += 20 * explosionSize.x
	particles2.amount += 10 * explosionSize.x
	particles3.amount += 20 * explosionSize.x
	
	particles1.lifetime = 0.25 * explosionSize.x
	particles2.lifetime = 0.25 * explosionSize.x
	particles3.lifetime = 0.25 * explosionSize.x
	
	particles1.speed_scale += 0.3 * explosionSize.x
	particles2.speed_scale += 0.3 * explosionSize.x
	particles3.speed_scale += 0.3 * explosionSize.x
	
	particles1.emitting = true
	particles2.emitting = true
	particles3.emitting = true
	await get_tree().create_timer(1.8).timeout
	queue_free()
