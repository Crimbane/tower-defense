extends Node2D

@export var projectileScene: PackedScene
var projectileSpawnPosition: Vector2 = Vector2.ZERO
@export var towerTop: AnimatedSprite2D
@export var weapon: Area2D
@export var fireRateTimer: Timer
@export var fireDurationTimer: Timer
@export var particles: CPUParticles2D
@export var mouseDetectionArea: Area2D
@export var attackRangeNode: Node2D

var isGhostShape: bool = false

var towerCost: int = 50

var canFire: bool = true
var isShooting: bool = false
@export var fireRate: float = 2.0
@export var fireDuration: float = 2.0
@export var fireDamage: int = 5
var fireBurnTime: float = 5
var attackRange: float = 500.0

var currentTarget = null


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


func onMouseEntered() -> void:
	if not isGhostShape:
		attackRangeNode.show()

func onMouseExited() -> void:
	if not isGhostShape:
		attackRangeNode.hide()

func onTowerMouseClick(_viewport: Node, event: InputEvent, _shapeidx: int ):
	if (event is InputEventMouseButton && event.pressed):
		print('Clicked')
		if not isGhostShape:
			print("not ghost")

func payForTower() -> void:
	towerCost = GameManager.fireTowerCost
	GameManager.removeMoney(towerCost)
