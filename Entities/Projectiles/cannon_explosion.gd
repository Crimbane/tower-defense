extends Area2D

var damage: int = 0

func _ready() -> void:
	await get_tree().physics_frame
	var enemies = get_overlapping_areas()
	
	#var enemy = area.get_parent()
	for enemy in enemies:
		if enemy.is_in_group("Enemy"):
			enemy.get_parent().takeDamage(damage)
	
	$AnimatedSprite2D.play("explosion")
	await get_tree().create_timer(1.8).timeout
	queue_free()
