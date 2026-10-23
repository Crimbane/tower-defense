extends Node

@export var spawnLocation: Path2D
@onready var nextWaveTimer: Timer = $"Next Wave Timer"
@onready var spawnTimer: Timer = $"Spawn Timer"

var spawnQueue: Array[PackedScene] = []

@export var enemyScene: PackedScene
@export var fastEnemyScene: PackedScene
@export var babySandwormScene: PackedScene
@export var scorpionScene: PackedScene
@export var boarScene: PackedScene
@export var lizardScene: PackedScene
@export var bossSandwormScene: PackedScene


@onready var enemyScenesArray: Array[PackedScene] = [
	babySandwormScene, scorpionScene, boarScene
	]

var enemyUnits: Dictionary = {}

var currentWave: int = 1
const MAX_WAVES: int = 100

@export var startingBudget: int = -1
@onready var budget: int = startingBudget

#TODO Make enemy types spawnable after certain wave number

func _ready() -> void:
	getEnemyData()
	spawnTimer.timeout.connect(onSpawnTimerTimeout)
	generateWave()
	nextWaveTimer.timeout.connect(checkIfEnemiesDead)


func _process(_delta: float) -> void:
	pass

func getEnemyData() -> void:
	for scene in enemyScenesArray:
		var tempEnemy = scene.instantiate()
		
		var cost = tempEnemy.unitCost
		var minWave = tempEnemy.minSpawnableWave
		enemyUnits[scene] = {
			"cost": cost,
			"minWave": minWave
		}
		
		tempEnemy.free()

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
		waveCompleted()

func spawnEnemy() -> void:
	var enemyToSpawn: PackedScene = spawnQueue.pop_front()
	var enemy = enemyToSpawn.instantiate()
	var spawnPosition = Vector2.ZERO
	
	enemy.position = spawnPosition
	
	spawnLocation.add_child(enemy)

func generateWave() -> void:
	var spawnList: Array[PackedScene] = []
	
	if currentWave >= MAX_WAVES:
		spawnBossWave()
		return
	
	
	var allowedUnits: Array[PackedScene] = []
	for unit in enemyUnits.keys():
		if currentWave >= enemyUnits[unit]["minWave"]:
			allowedUnits.append(unit)
	
	
	budget = calculateBudget(currentWave)
	
	var attempts: int = 0
	while budget > 0 and attempts < 100:
		attempts += 1
		var randomUnit: PackedScene = allowedUnits.pick_random()
		
		var unitCost: int = enemyUnits[randomUnit]["cost"]
		
		if unitCost <= budget:
			spawnList.append(randomUnit)
			budget -= unitCost
	
	startWave(spawnList)


func spawnBossWave() -> void:
	pass

func calculateBudget(wave) -> int:
	budget = startingBudget + (wave * 2)
	print("budget: ", budget)
	return budget

func waveCompleted() -> void:
	currentWave += 1

func checkIfEnemiesDead() -> void:
	var enemiesAlive: int = spawnLocation.get_child_count()
	#print("enemies alive: ", enemiesAlive)
	if enemiesAlive == 0:
		generateWave()
