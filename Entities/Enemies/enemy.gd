extends PathFollow2D

@onready var hitbox: Area2D = $Hitbox

@export var sprite: Sprite2D
@export var burnTimer: Timer
var time: float = 0.0

@export var unitCost: int = 0
@export var attackDamage: int = 1
@export var maxHealth = 50
@onready var currentHealth: int = maxHealth
@export var baseSpeed: float = 0.5
@onready var currentSpeed: float = baseSpeed

var isBurning: bool = false
var fireDamage: int = 0
var burnTime: float = 0.0
var burnTicks: float = 0.5

var activeIceFields: int = 0
var slowStength: float = 1.0

@onready var healthBar = $"Health Bar"
@onready var collisionShape: CollisionShape2D = $Hitbox/CollisionShape2D

var healthBarSizeHeight = 80
var healthBarOffsetHeight = -25


func _ready() -> void:
	loop = false
	placeHealthBar()
	burnTimer.timeout.connect(onStopBurning)

func _process(delta: float) -> void:
	healthBar.rotation_degrees = 0
	time += delta
	
	if progress_ratio == 1.0:
		print("reached end of path")
		queue_free()
	
	if burnTimer.time_left != 0:
		if time > burnTicks:
			time = 0
			takeDamage(fireDamage)
	
	if activeIceFields > 0:
		currentSpeed = baseSpeed * slowStength
	
	progress += currentSpeed
	
	if collisionShape and collisionShape.shape is RectangleShape2D:
		var collisionSizeHeight = collisionShape.shape.size.y
		healthBar.global_position.x = global_position.x - (healthBar.size.x / 2)
		healthBar.global_position.y = global_position.y - (collisionSizeHeight / 2) - healthBar.size.y - healthBarOffsetHeight
		healthBar.rotation_degrees = 0


func takeDamage(damage: int) -> void:
	currentHealth -= damage
	#print("damaged: ", damage)
	if currentHealth < 1:
		queue_free()
	
	healthBar.value = currentHealth
	healthBar.visible = true


func applyFireDebuff(damage: int, fireBurnTime: float) -> void:
	fireDamage = damage
	burnTime = fireBurnTime
	isBurning = true
	burnTimer.wait_time = burnTime
	burnTimer.call_deferred("start")
	
	sprite.modulate = Color.FIREBRICK

func onStopBurning() -> void:
	isBurning = false
	sprite.modulate = Color(1,1,1,1) # default


func applySlowDebuff(slowPercent: float) -> void:
	activeIceFields += 1
	
	slowStength = slowPercent

func removeSlowDebuff() -> void:
	activeIceFields -= 1
	
	if activeIceFields <= 0:
		slowStength = 1.0
		currentSpeed = baseSpeed


func placeHealthBar() -> void:
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	if collisionShape.shape is RectangleShape2D:
		var collisionSizeWidth = collisionShape.shape.size.x
		var collisionSizeHeight = collisionShape.shape.size.y
		healthBar.size = Vector2(collisionSizeWidth, healthBarSizeHeight)
		
		#healthBar.position.x = -healthBar.size.x / 2
		#healthBar.position.y = -collisionSizeHeight / 2 - healthBar.size.y - healthBarOffsetHeight
