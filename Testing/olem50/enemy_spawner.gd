extends Path2D

@export var waveManager: Node

@export var spawnTimer: Timer

var spawnQueue: Array[PackedScene] = []


func _ready() -> void:
	spawnTimer.timeout.connect(onSpawnTimerTimeout)

func _process(_delta: float) -> void:
	pass
	

func startWave(spawnList: Array[PackedScene]) -> void:
	spawnQueue = spawnList
	
	if not spawnQueue.is_empty():
		spawnEnemy()
		spawnTimer.start()

func onSpawnTimerTimeout() -> void:
	if not spawnQueue.is_empty():
		spawnEnemy()
		spawnTimer.start()
	else:
		waveManager.waveCompleted()

func spawnEnemy() -> void:
	var enemyScene: PackedScene = spawnQueue.pop_front()
	var enemy = enemyScene.instantiate()
	var spawnPosition = Vector2.ZERO
	
	enemy.position = spawnPosition
	
	add_child(enemy)
