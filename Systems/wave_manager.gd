extends Node

@export var enemySpawner: Path2D
@onready var nextWaveTimer: Timer = $"Next Wave Timer"

@export var enemyScene: PackedScene
var enemyCost: int = 1
@export var fastEnemyScene: PackedScene
var fastEnemyCost: int = 2

@onready var enemyUnits: Dictionary[PackedScene, int] = {
	enemyScene: enemyCost,
	fastEnemyScene: fastEnemyCost
}

var currentWave: int = 1
const MAX_WAVES: int = 100

@export var startingBudget: int = -1
@onready var budget: int = startingBudget

#TODO Make enemy types spawnable after certain wave number

func _ready() -> void:
	generateWave()
	nextWaveTimer.timeout.connect(generateWave)


func _process(_delta: float) -> void:
	pass


func generateWave() -> void:
	var spawnList: Array[PackedScene] = []
	
	if currentWave >= MAX_WAVES:
		spawnBossWave()
		return
	
	budget = calculateBudget(currentWave)
	
	var attempts: int = 0
	while budget > 0 and attempts < 100:
		attempts += 1
		var unitsArray: Array[PackedScene] = enemyUnits.keys()
		var randomUnit: PackedScene = unitsArray.pick_random()
		
		var unitCost: int = enemyUnits[randomUnit]
		
		if unitCost <= budget:
			spawnList.append(randomUnit)
			budget -= unitCost
	
	enemySpawner.startWave(spawnList)


func spawnBossWave() -> void:
	pass

func calculateBudget(wave) -> int:
	budget = startingBudget + (wave * 2)
	return budget


func waveCompleted() -> void:
	currentWave += 1
	nextWaveTimer.start()
