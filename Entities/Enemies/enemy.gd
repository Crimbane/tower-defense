extends PathFollow2D

@onready var hitbox: Area2D = $Hitbox

@export var sprite: Sprite2D
@export var burnTimer: Timer
var time: float = 0.0

var health = 50
@export var baseSpeed: float = 0.5
@onready var currentSpeed: float = baseSpeed

var isBurning: bool = false
var fireDamage: int = 0
var burnTime: float = 0.0
var burnTicks: float = 0.5

var activeIceFields: int = 0
var slowStength: float = 1.0


func _ready() -> void:
	loop = false
	burnTimer.timeout.connect(onStopBurning)

func _process(delta: float) -> void:
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


func takeDamage(damage: int) -> void:
	health -= damage
	#print("damaged: ", damage)
	if health < 1:
		queue_free()


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
