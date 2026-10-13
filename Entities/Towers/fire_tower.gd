extends Node2D

@export var projectileScene: PackedScene
var projectileSpawnPosition: Vector2 = Vector2.ZERO
@export var towerTop: AnimatedSprite2D
@export var weapon: Area2D
@export var fireRateTimer: Timer
@export var fireDurationTimer: Timer
@export var particles: CPUParticles2D

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


func _process(_delta: float) -> void:
	currentTarget = findClosestEnemy()
	
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
	weapon.set_deferred("monitoring", false)
	particles.emitting = false
	fireRateTimer.start()


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
