extends PathFollow2D

@export_enum(
	"Baby Sandworm", "Scorpion", "Boar", "Lizard", "Boss") var enemyType: String = "Boar"


@onready var hitbox: Area2D = $Hitbox
@onready var collisionShape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var healthBar: TextureProgressBar = $"Health Bar"
@export var armorBar: TextureProgressBar

@export var sprite: AnimatedSprite2D
@export var burnTimer: Timer
var time: float = 0.0

@export var unitCost: int = 1
@export var minSpawnableWave: int = 1
@export var attackDamage: int = 1
@export var maxHealth = 50
@onready var currentHealth: int = maxHealth
@export var baseSpeed: int = 100
@onready var currentSpeed: float = baseSpeed
@export var armor: int = 0

var isBurning: bool = false
var fireDamage: int = 0
var burnTime: float = 0.0
var burnTicks: float = 0.5

var activeSlowFields: int = 0
var slowStrength: float = 1.0


var healthBarSizeHeight = 8
var healthBarOffsetHeight = 25


func _ready() -> void:
	loop = false
	enemySpecificLogic()
	placeHealthBar()
	burnTimer.timeout.connect(onStopBurning)
	if armorBar:
		armorBar.max_value = armor

func _process(delta: float) -> void:
	healthBar.rotation_degrees = 0
	time += delta
	
	if progress_ratio == 1.0:
		onPathCompletion()
	
	if burnTimer.time_left != 0:
		if time > burnTicks:
			time = 0
			if armorBar:
				armorBar.value -= fireDamage
				armor -= fireDamage
			takeDamage(fireDamage)
	
	if activeSlowFields > 0:
		currentSpeed = baseSpeed * slowStrength 
	
	progress += currentSpeed * delta
	
	if collisionShape and collisionShape.shape is RectangleShape2D:
		var collisionSizeHeight = collisionShape.shape.size.y
		healthBar.global_position.x = global_position.x - (healthBar.size.x / 2)
		healthBar.global_position.y = global_position.y - (collisionSizeHeight / 2) - healthBar.size.y - healthBarOffsetHeight
		#healthBar.rotation_degrees = 0
		if armorBar:
			#armorBar.rotation_degrees = 0
			armorBar.global_position.x = healthBar.global_position.x
			armorBar.global_position.y = healthBar.global_position.y #- armorBar.size.y


func takeDamage(damage: int) -> void:
	if armor > 0:
		armorBar.show()
		print("armored, take no damage")
		return
	currentHealth -= damage
	#print("damaged: ", damage)
	if currentHealth < 1:
		if enemyType == "Boss":
			pass
			# won the game logic
		if enemyType == "Baby Sandworm":
			SoundManager.playSandwormDeathSound()
		if enemyType == "Scorpion":
			SoundManager.playScorpionDeathSound()
		if enemyType == "Boar":
			SoundManager.playBoarDeathSound()
		if enemyType == "Lizard":
			SoundManager.playLizardDeathSound()
		GameManager.increaseMoney(unitCost * GameManager.moneyMultiplier)
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
	activeSlowFields += 1
	
	slowStrength = slowPercent

func removeSlowDebuff() -> void:
	activeSlowFields -= 1
	
	if activeSlowFields <= 0:
		slowStrength = 1.0
		currentSpeed = baseSpeed

func onPathCompletion() -> void:
	if GameManager.nexus != null:
		GameManager.nexus.takeDamage(attackDamage)
	queue_free()

func placeHealthBar() -> void:
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	if collisionShape.shape is RectangleShape2D:
		var collisionSizeWidth = collisionShape.shape.size.x
		healthBar.size.x = collisionSizeWidth


func enemySpecificLogic() -> void:
	match enemyType:
		"Baby Sandworm":
			healthBarOffsetHeight = 25
		"Scorpion":
			pass
		"Boar":
			healthBarOffsetHeight = 25
		"Lizard":
			pass
