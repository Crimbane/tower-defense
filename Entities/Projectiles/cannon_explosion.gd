extends Area2D

var damage: int = 0
var explosionSize = scale

func _ready() -> void:
	scale = explosionSize
	await get_tree().physics_frame
	var enemies = get_overlapping_areas()
	
	#var enemy = area.get_parent()
	for enemy in enemies:
		if enemy.is_in_group("Enemy"):
			enemy.get_parent().takeDamage(damage)
	
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	await get_tree().create_timer(1.8).timeout
	queue_free()
