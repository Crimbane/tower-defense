extends Node2D

@export var projectileScene: PackedScene
var projectileSpawnPosition: Vector2 = Vector2.ZERO
@export var towerTop: AnimatedSprite2D
@export var fireRateTimer: Timer

var canFire: bool = true
@export var fireRate: float = 0.5
var attackRange: float = 500.0

var currentTarget = null


func _ready() -> void:
	fireRateTimer.wait_time = fireRate
	fireRateTimer.timeout.connect(onFireRateTimerTimeout)


func _process(_delta: float) -> void:
	currentTarget = findClosestEnemy()
	
	if currentTarget != null:
		var distance = position.distance_to(currentTarget.global_position)
		if distance < attackRange:
			towerTop.look_at(currentTarget.global_position)
			towerTop.rotation += PI / 2 
			
			if canFire:
				shoot()


func shoot() -> void:
	canFire = false
	fireRateTimer.start()
	
	var projectile = projectileScene.instantiate()
	var spawnPosition = self.global_position
	
	var direction = (currentTarget.global_position - spawnPosition).normalized()
	
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
