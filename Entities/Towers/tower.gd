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

var canFire: bool = true
@export var fireRate: float = 0.5
@export var attackRange: float = 250.0
@export var projectileSpeed: int = 500

#Upgrades
var leftTier: int = 0
var middleTier: int = 0
var rightTier: int = 0

var currentTier: int = 0
const MAX_TIER: int = 4

var leftTierCosts: Array[int] = GameManager.leftTierCosts
var middleTierCosts: Array[int] = GameManager.middleTierCosts
var rightTierCosts: Array[int] = GameManager.rightTierCosts

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
		return
	currentTarget = findClosestEnemy()
	
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
	
	get_tree().current_scene.add_child(projectile)


func onFireRateTimerTimeout() -> void:
	canFire = true


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
	if (event is InputEventMouseButton && event.pressed):
		if not isGhostShape:
			#upgradeTower("Right")
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


func upgradeTower(upgradePath: String, upgradeTier: String) -> void:
	if currentTier >= MAX_TIER:
		print("Tower maxed")
		return
	
	var targetTier: int = int(upgradeTier)
	if targetTier != (currentTier + 1):
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
		currentTier += 1
		
		match upgradePath:
			"Left":
				leftTier = targetTier
				damage *= 2
			"Middle":
				middleTier = targetTier
				fireRate *= 0.5
				fireRateTimer.wait_time = fireRate
			"Right":
				rightTier = targetTier
				attackRange *= 2
				attackRangeNode.updateAttackRange()
	else:
		print("You are poor")
