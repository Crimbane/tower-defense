extends Node2D

@export_enum(
	"Arrow", "Ice", "Cannon") var towerType: String = "Arrow"

@export var projectileScene: PackedScene
var projectileSpawnPosition: Vector2 = Vector2.ZERO
@export var towerTop: AnimatedSprite2D
@export var fireRateTimer: Timer

var isGhostShape: bool = false

@export var damage: int = 10
#@export var arrowDamage: int = 10
#@export var iceDamage: int = 1
#@export var cannonDamage: int = 50

var canFire: bool = true
@export var fireRate: float = 0.5
@export var attackRange: float = 500.0
@export var projectileSpeed: int = 500


var currentTarget = null


func _ready() -> void:
	fireRateTimer.wait_time = fireRate
	fireRateTimer.timeout.connect(onFireRateTimerTimeout)


func _process(_delta: float) -> void:
	if isGhostShape:
		return
	currentTarget = findClosestEnemy()
	
	if currentTarget != null:
		var distance = position.distance_to(currentTarget.global_position)
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
	#match towerType:
		#"Arrow":
			#projectile.damage = arrowDamage
		#"Ice":
			#projectile.damage = iceDamage
		#"Cannon":
			#projectile.damage = cannonDamage
	
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
