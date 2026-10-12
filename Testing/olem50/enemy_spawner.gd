extends Path2D
@export var enemyScene: PackedScene

var time: float = 0.0
var spawnTimer: float = 3.0

func _process(delta: float) -> void:
	time += delta
	
	if time > spawnTimer:
		time = 0
		spawnEnemy()


func spawnEnemy() -> void:
	var enemy = enemyScene.instantiate()
	var spawnPosition = Vector2.ZERO
	
	enemy.position = spawnPosition
	
	add_child(enemy)
