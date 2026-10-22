extends Node2D

var towerType = "Fire"

@export var projectileScene: PackedScene
var projectileSpawnPosition: Vector2 = Vector2.ZERO
@export var towerTop: AnimatedSprite2D
@export var weapon: Area2D
@export var weaponCollision: CollisionPolygon2D
@export var weaponVisualPolygon: Polygon2D
@export var fireRateTimer: Timer
@export var fireDurationTimer: Timer
@export var particles: CPUParticles2D
@export var mouseDetectionArea: Area2D
@export var attackRangeNode: Node2D
var currentTarget = null

var isGhostShape: bool = false

var towerCost: int = 0

var canFire: bool = true
var isShooting: bool = false

@export_category("Stats")
@export var fireRate: float = 2.0
@export var fireDuration: float = 2.0
@export var fireDamage: int = 5
var fireBurnTime: float = 5
@export var attackRange: float = 250.0

var fireRange: float = 800.0

#Upgrades
var currentTier: int = 0
const MAX_TIER: int = 4

var leftTierCosts: Array[int] = GameManager.leftTierCosts
var middleTierCosts: Array[int] = GameManager.middleTierCosts
var rightTierCosts: Array[int] = GameManager.rightTierCosts

var upgradePurchaseHistory: Array[String] = ["None", "None", "None", "None"]


func _ready() -> void:
	fireRateTimer.wait_time = fireRate
	fireDurationTimer.wait_time = fireDuration
	fireRateTimer.timeout.connect(onFireRateTimerTimeout)
	fireDurationTimer.timeout.connect(onStopShooting)
	
	weapon.area_entered.connect(applyFire)
	weapon.area_exited.connect(applyFire)
	particles.finished.connect(weapon.hide)
	weapon.monitoring = false
	weapon.visible = false
	particles.emitting = false
	
	if mouseDetectionArea:
		mouseDetectionArea.mouse_entered.connect(onMouseEntered)
		mouseDetectionArea.mouse_exited.connect(onMouseExited)
		mouseDetectionArea.input_event.connect(onTowerMouseClick)
	adjustFireCollision()


func _process(_delta: float) -> void:
	if isGhostShape:
		return
	currentTarget = findPriorityEnemy()
	
	if currentTarget != null:
		var distance = position.distance_to(currentTarget.global_position)
		if distance < attackRange:
			towerTop.look_at(currentTarget.global_position)
			towerTop.rotation += PI / 2
			weapon.look_at(currentTarget.global_position)
			weapon.rotation += PI / 2
			
			if canFire:
				shoot()


func shoot() -> void:
	canFire = false
	fireDurationTimer.start()
	weapon.show()
	particles.emitting = true
	weapon.set_deferred("monitoring", true)
	

func applyFire(body: Area2D) -> void:
	if body.is_in_group("Enemy"):
		var enemy = body.get_parent()
		enemy.applyFireDebuff(fireDamage, fireBurnTime)

func onStopShooting() -> void:
	var enemiesInside = weapon.get_overlapping_areas()
	for body in enemiesInside:
		applyFire(body)
	
	weapon.set_deferred("monitoring", false)
	particles.emitting = false
	fireRateTimer.start()


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
	if not isGhostShape:
		attackRangeNode.hide()

func onTowerMouseClick(_viewport: Node, event: InputEvent, _shapeidx: int ):
	if (event is InputEventMouseButton && event.pressed):
		if not isGhostShape:
			GameManager.selectedTower = self
			GameManager.UIManager.placeTowerUpgradeMenu()

func payForTower() -> void:
	towerCost = GameManager.fireTowerCost
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
		"Fire":
			#damage, firerate, range increase
			match upgradePath:
				"Left":
					if upgradeTier == 4:
						fireDamage += upgradeData["tier4"]
					else:
						fireDamage += upgradeData["damageIncrease"]
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
					adjustFireCollision()


func adjustFireCollision() -> void:
	var yOffset = -163.333 #weapon.position.y
	var length: float = attackRange * 4 + yOffset
	#var width: float = 300.0
	var width: float = length * 0.375
	var polygonArray: PackedVector2Array = [
		Vector2.ZERO, 
		Vector2(width, -length ), 
		Vector2(-width, -length)
		]
	
	weaponCollision.polygon = polygonArray
	weaponVisualPolygon.polygon = polygonArray
	
	var uvArray: PackedVector2Array = [
		Vector2(0.5, 1.0),
		Vector2(1.0, 0.0),
		Vector2(0.0, 0.0)
	]
	weaponVisualPolygon.uv = uvArray
