extends Node2D

@export var projectileScene: PackedScene
var projectileSpawnPosition: Vector2 = Vector2.ZERO
@export var fireRateTimer: Timer

var time: float = 0.0

var canFire: bool = true
@export var fireRate: float = 0.5

func _ready() -> void:
	fireRateTimer.wait_time = fireRate
	fireRateTimer.timeout.connect(onFireRateTimerTimeout)
	pass # Replace with function body.


func _process(_delta: float) -> void:
	#time += delta
	
	#if time > fireRate:
		#time = 0
		#canFire = true
		
	if canFire:
		var distance = position.distance_to(get_global_mouse_position())
		if distance < 500:
			shoot()
	
	if Input.is_action_just_pressed("Left Click"):
		shoot()

func shoot() -> void:
	canFire = false
	fireRateTimer.start()
	
	var projectile = projectileScene.instantiate()
	var spawnPosition = self.global_position
	
	var direction = (get_global_mouse_position() - spawnPosition).normalized()
	
	projectile.global_position = spawnPosition
	projectile.direction = direction
	projectile.rotation = direction.angle()
	
	get_tree().current_scene.add_child(projectile)

func onFireRateTimerTimeout() -> void:
	canFire = true
