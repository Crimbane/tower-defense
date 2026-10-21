extends Node2D

@export_enum(
	"Arrow", "Slime", "Cannon") var towerType: String = "Arrow"

@export var projectileScene: PackedScene
var projectileSpawnPosition: Vector2 = Vector2.ZERO
@export var towerTop: AnimatedSprite2D
@export var fireRateTimer: Timer
@export var mouseDetectionArea: Area2D
@export var attackRangeNode: Node2D
var currentTarget = null

var isGhostShape: bool = false

var towerCost: int = 50

@export var damage: int = 10
var cannonExplosionSize = Vector2(1, 1)
var slimeSlowPercent: float = 0.7

var canFire: bool = true
@export var fireRate: float = 0.5
@export var attackRange: float = 250.0
@export var projectileSpeed: int = 500

#Upgrades
var currentTier: int = 0
const MAX_TIER: int = 4

var leftTierCosts: Array[int] = GameManager.leftTierCosts
var middleTierCosts: Array[int] = GameManager.middleTierCosts
var rightTierCosts: Array[int] = GameManager.rightTierCosts

var upgradePurchaseHistory: Array[String] = ["None", "None", "None", "None"]


func _ready() -> void:
	print(leftTierCosts)
	fireRateTimer.wait_time = fireRate
	fireRateTimer.timeout.connect(onFireRateTimerTimeout)
	
	if mouseDetectionArea:
		mouseDetectionArea.mouse_entered.connect(onMouseEntered)
		mouseDetectionArea.mouse_exited.connect(onMouseExited)
		mouseDetectionArea.input_event.connect(onTowerMouseClick)


func _process(_delta: float) -> void:
	if isGhostShape:
		z_index = 5
		return
	#currentTarget = findClosestEnemy()
	currentTarget = findPriorityEnemy()
	
	if currentTarget != null:
		var distance = global_position.distance_to(currentTarget.global_position)
		if distance < attackRange:
			towerTop.look_at(currentTarget.global_position)
			towerTop.rotation += PI / 2 
			
			if canFire:
				shoot()


func shoot() -> void:
	if isGhostShape:
		return
	canFire = false
	fireRateTimer.start()
	
	var projectile = projectileScene.instantiate()
	var spawnPosition = self.global_position
	
	var direction = (currentTarget.global_position - spawnPosition).normalized()
	
	projectile.projectileType = towerType
	projectile.damage = damage
	projectile.speed = projectileSpeed
	
	projectile.global_position = spawnPosition
	projectile.direction = direction
	projectile.rotation = direction.angle()
	projectile.target = currentTarget
	
	if towerType == "Cannon":
		projectile.explosionSize = cannonExplosionSize
	elif towerType == "Slime":
		projectile.slowPercent = slimeSlowPercent
	
	get_tree().current_scene.add_child(projectile)


func onFireRateTimerTimeout() -> void:
	canFire = true


func findPriorityEnemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var priorityEnemy: Node2D = null
	var highestProgress = 0
	
	for enemy in enemies:
		var enemyDistance = global_position.distance_to(enemy.global_position)
		if enemyDistance < attackRange:
			var progress = enemy.get_parent().progress
			if progress > highestProgress:
				highestProgress = progress
				priorityEnemy = enemy
	
	return priorityEnemy

func findClosestEnemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var closestEnemy: Node2D = null
	var closestDistance = attackRange
	
	for enemy in enemies:
		var enemyDistance = global_position.distance_to(enemy.global_position)
		if enemyDistance < closestDistance:
			closestDistance = enemyDistance
			closestEnemy = enemy
	
	return closestEnemy

func showAttackRange() -> void:
	attackRangeNode.show()
func hideAttackRange() -> void:
	attackRangeNode.hide()

func onMouseEntered() -> void:
	if not isGhostShape:
		attackRangeNode.show()

func onMouseExited() -> void:
	if not isGhostShape and GameManager.selectedTower == null:
		attackRangeNode.hide()

func onTowerMouseClick(_viewport: Node, event: InputEvent, _shapeidx: int ):
	if (event is InputEventMouseButton && event.is_action_pressed("Left Click")):
		if not isGhostShape:
			GameManager.selectedTower = self
			GameManager.UIManager.placeTowerUpgradeMenu()

func payForTower() -> void:
	match towerType:
		"Arrow":
			towerCost = GameManager.arrowTowerCost
		"Slime":
			towerCost = GameManager.slimeTowerCost
		"Cannon":
			towerCost = GameManager.cannonTowerCost
	GameManager.removeMoney(towerCost)


func upgradeTower(upgradePath: String, upgradeTier: int) -> void:
	if currentTier >= MAX_TIER:
		print("Tower maxed")
		return
	
	if upgradeTier != (currentTier + 1):
		print("Wrong upgrade tier")
		return
	
	var cost: int = 0
	match upgradePath:
		"Left":
			cost = leftTierCosts[currentTier]
		"Middle":
			cost = middleTierCosts[currentTier]
		"Right":
			cost = rightTierCosts[currentTier]
	
	if GameManager.money >= cost:
		GameManager.removeMoney(cost)
		upgradePurchaseHistory[currentTier] = upgradePath
		currentTier += 1
		
		applyTowerUpgrades(upgradePath, upgradeTier)
		
		GameManager.UIManager.updateTowerUpgradeMenuColors()
	else:
		print("You are poor")

func applyTowerUpgrades(upgradePath: String, upgradeTier: int) -> void:
	var upgradeData: Dictionary = GameManager.TOWER_UPGRADES[towerType][upgradePath]
	
	match towerType:
		"Arrow":
			match upgradePath:
				"Left":
					if upgradeTier == 4:
						damage += upgradeData["tier4"]
					else:
						damage += upgradeData["damageIncrease"]
				"Middle":
					if upgradeTier == 4:
						fireRate *= upgradeData["tier4"]
					else:
						fireRate *= upgradeData["fireRateIncreaseMultiplier"]
					fireRateTimer.wait_time = fireRate
				"Right":
					if upgradeTier == 4:
						attackRange *= upgradeData["tier4"]
					else:
						attackRange *= upgradeData["rangeIncreaseMultiplier"]
					attackRangeNode.updateAttackRange()
		"Fire":
			#damage, firerate, range increase
			match upgradePath:
				"Left":
					if upgradeTier == 4:
						damage += upgradeData["tier4"]
					else:
						damage += upgradeData["damageIncrease"]
				"Middle":
					if upgradeTier == 4:
						fireRate *= upgradeData["tier4"]
					else:
						fireRate *= upgradeData["fireRateIncreaseMultiplier"]
					fireRateTimer.wait_time = fireRate
				"Right":
					if upgradeTier == 4:
						attackRange *= upgradeData["tier4"]
					else:
						attackRange *= upgradeData["rangeIncreaseMultiplier"]
					attackRangeNode.updateAttackRange()
		"Slime":
			#slow strength, firerate, small range increase
			match upgradePath:
				"Left":
					if upgradeTier == 4:
						slimeSlowPercent -= upgradeData["tier4"]
					else:
						slimeSlowPercent -= upgradeData["slowIncreasePercent"]
				"Middle":
					if upgradeTier == 4:
						fireRate *= upgradeData["tier4"]
					else:
						fireRate *= upgradeData["fireRateIncreaseMultiplier"]
					fireRateTimer.wait_time = fireRate
				"Right":
					if upgradeTier == 4:
						attackRange *= upgradeData["tier4"]
					else:
						attackRange *= upgradeData["rangeIncreaseMultiplier"]
					attackRangeNode.updateAttackRange()
		"Cannon":
			#explosion aoe, firerate, range increase
			match upgradePath:
				"Left":
					if upgradeTier == 4:
						cannonExplosionSize += upgradeData["tier4"]
					else:
						cannonExplosionSize += upgradeData["explosionSizeIncrease"]
				"Middle":
					if upgradeTier == 4:
						fireRate *= upgradeData["tier4"]
					else:
						fireRate *= upgradeData["fireRateIncreaseMultiplier"]
					fireRateTimer.wait_time = fireRate
				"Right":
					if upgradeTier == 4:
						attackRange *= upgradeData["tier4"]
					else:
						attackRange *= upgradeData["rangeIncreaseMultiplier"]
					attackRangeNode.updateAttackRange()
