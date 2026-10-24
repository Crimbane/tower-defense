extends Area2D

var slowPercent: float = 0.5
var fieldDuration: float = 4


func _ready() -> void:
	area_entered.connect(onEnemyEntered)
	area_exited.connect(onEnemyExited)
	
	$Sprite2D.rotation_degrees = randf_range(0.0, 360.0)
	
	await get_tree().create_timer(fieldDuration).timeout
	destroyField()
	queue_free()

func _process(_delta: float) -> void:
	pass

func onEnemyEntered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		var enemy = area.get_parent()
		enemy.applySlowDebuff(slowPercent)

func onEnemyExited(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		var enemy = area.get_parent()
		enemy.removeSlowDebuff()

func destroyField() -> void:
	var enemiesInField = get_overlapping_areas()
	for area in enemiesInField:
		onEnemyExited(area)
	
	queue_free()
